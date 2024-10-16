using DAL;
using EpicSolutions.Model;
using EpicSolutions.Types;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.ComponentModel.Design;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EpicSolutions.Repo
{
    public class DepartmentRepo
    {

        #region Private Fields

        private readonly DataAccess db = new();


        #endregion


        #region Public Methods


        public Department AddDepartment(Department d)
        {
            List<Parm> parms = new()
            {
                new Parm("@DepartmentName", SqlDbType.NVarChar, d.Name, 128),
                new Parm("@Description", SqlDbType.NVarChar, d.Description, 512),
                new Parm("@InvocationDate", SqlDbType.DateTime2, (object)d.InvocationDate ?? DBNull.Value),
                new Parm("@DepartmentId", SqlDbType.Int, null, 0, ParameterDirection.Output),
                new Parm("@RecordVersion", SqlDbType.Timestamp, null, 0, ParameterDirection.Output)

            };
            if (db.ExecuteNonQuery("spAddDepartment", parms) > 0)
            {
                d.Id = (int?)parms.FirstOrDefault(p => p.Name == "@DepartmentId")?.Value ?? 0;
                d.RecordVersion = (byte[]?)parms.FirstOrDefault(p => p.Name == "@RecordVersion")?.Value;
            }
            else
            {
                throw new DataException("There was an error adding the department.");
            }

            return d;
        }

        public Department UpdateDepartment(Department d)
        {
            try
            {
                List<Parm> parms = new()
            {
                new Parm("@RecordVersion", SqlDbType.Timestamp, d.RecordVersion, 0,  ParameterDirection.Input),
                new Parm("@DepartmentId", SqlDbType.Int, d.Id),
                new Parm("@DepartmentName", SqlDbType.NVarChar, d.Name, 128),
                new Parm("@Description", SqlDbType.NVarChar, d.Description, 512),
                new Parm("@InvocationDate", SqlDbType.DateTime2, d.InvocationDate),
                new Parm("@NewRecordVersion", SqlDbType.Timestamp, null, 0, ParameterDirection.Output)
        };


                int rowsAffected = db.ExecuteNonQuery("spUpdateDepartment", parms);

                if (rowsAffected > 0)
                {
                    d.RecordVersion = (byte[]?)parms.FirstOrDefault(p => p.Name == "@NewRecordVersion")?.Value;  
                    return d;
                }
                else
                {                   
                    throw new InvalidOperationException("No changes were made to the department record. This may be due to no changes in data or concurrent updates.");
                }
            }
            catch (SqlException ex) when (ex.Number == 51002) 
            {
                throw new InvalidOperationException("The department has been updated by another user. Please refresh and try again.", ex);
            }
            catch (SqlException ex) when (ex.Number == 50001)
            {
                throw new InvalidOperationException("No such department exists. It may have been deleted by another user.", ex);
            }
            catch (Exception ex)
            {
                throw new DataException(ex.Message);
            }

        }

        public string GetDepartmentNameById(int departmentId)
        {
            string departmentName = "";

            List<Parm> parms = new()
            {
                new Parm("@DepartmentId", SqlDbType.Int, departmentId)
            };

            DataTable dt = db.Execute("spGetDepartmentNameById", parms);

            if (dt.Rows.Count > 0)
            {
                departmentName = Convert.ToString(dt.Rows[0]["DepartmentName"]);
            }

            return departmentName;

        }

        public int GetDepartmentByPositionId(int positionId)
        {
            int departmentId = -1;

            List<Parm> parms = new()
            {
                new Parm("@PositionId", SqlDbType.Int, positionId)
            };

            DataTable dt = db.Execute("spGetDepartmentByPositionId", parms);

            if (dt.Rows.Count > 0)
            {
                departmentId = Convert.ToInt32(dt.Rows[0]["DepartmentId"]);
            }
            else
            {
                Console.WriteLine($"No department found for position ID: {positionId}");
            }

            return departmentId;

        }

        public DateTime? GetDepartmentInvocationDateById(int departmentId)
        {
            DateTime? departmentInvocationDate = null;

            List<Parm> parms = new()
            {
                new Parm("@DepartmentId", SqlDbType.Int, departmentId)
            };

            DataTable dt = db.Execute("spGetDepartmentInvocationDateById", parms);

            if (dt.Rows.Count > 0)
            {
                if (dt.Rows[0]["InvocationDate"] != DBNull.Value)
                {
                    departmentInvocationDate = Convert.ToDateTime(dt.Rows[0]["InvocationDate"]);
                }
            }

            return departmentInvocationDate;

        }

        public async Task<List<DepartmentDTO>> GetAllActiveDepartmentsAsync()
        {
            List<Parm> parms = new()
            {
                new Parm("@ExcludeDepartmentId", SqlDbType.Int, 16)
            };

            DataTable dt = await db.ExecuteAsync("spGetAllActiveDepartmentsExceptOne", parms);

            return dt.AsEnumerable().Select(row => PopulateDepartmentDTO(row)).ToList();
        }

        public List<Department> GetAllDepartments()
        {

            try
            {
                List<Parm> parms = new()
            {
                new Parm("@ExcludeDepartmentId", SqlDbType.Int, 16)
            };

                DataTable dt = db.Execute("spGetAllDepartmentsExceptOne", parms);

                if (dt != null && dt.Rows.Count > 0)
                {
                    List<Department> departments = new List<Department>();

                    foreach (DataRow row in dt.Rows)
                    {
                        Department department = PopulateDepartment(row);
                        departments.Add(department);
                    }

                    return departments;
                }
                else
                {
                    return new List<Department>();
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }


        public Department GetDepartmentByEmployeeId(int employeeId)
        {

            List<Parm> parms = new()
            {
                new Parm("@EmployeeId", SqlDbType.Int, employeeId)
            };

            DataTable dt = db.Execute("spGetDepartmentByEmployeeId", parms);

            if (dt != null && dt.Rows.Count > 0)
            {
                DataRow row = dt.Rows[0];
                Department department = new Department
                {

                    Id = Convert.ToInt32(row["DepartmentId"]),
                    Name = row["DepartmentName"].ToString(),
                    Description = row["Description"].ToString(),
                    InvocationDate = (DateTime)(row["InvocationDate"]),
                    RecordVersion = (byte[])row["RecordVersion"]
                };

                return department;
            }
            else
            {
                return null;
            }
        }

        public Department GetDepartmentById(int departmentId)
        {

            List<Parm> parms = new()
            {
                new Parm("@DepartmentId", SqlDbType.Int, departmentId)
            };

            DataTable dt = db.Execute("spGetDepartmentById", parms);

            if (dt != null && dt.Rows.Count > 0)
            {
                DataRow row = dt.Rows[0];
                Department department = new Department
                {

                    Id = Convert.ToInt32(row["DepartmentId"]),
                    Name = row["DepartmentName"].ToString(),
                    Description = row["Description"].ToString(),
                    InvocationDate = (DateTime)(row["InvocationDate"]),
                    RecordVersion = (byte[])row["RecordVersion"]
                };

                return department;
            }
            else
            {
                return null;
            }
        }

        public bool IsDepartmantNameIsUnique(string departmentName)
        {
            List<Parm> parms = new()
            {
                new Parm("@DepartmentName", SqlDbType.NVarChar, departmentName, 128)
            };

            DataTable dt = db.Execute("spIsDepartmantNameIsUnique", parms);

            return dt.Rows.Count == 0;
        }

  
        public bool IsDepartmentValidForDelete(int departmentId)
        {
            List<Parm> parms = new()
            {
                new Parm("@DepartmentId", SqlDbType.Int, departmentId)
            };

            DataTable dt = db.Execute("spIsDepartmentValidForDelete", parms);

           
            return dt.Rows.Count == 0;
        }

        public bool DeleteDepartment(int departmentId)
        {
            try
            {
                List<Parm> parms = new()
                    {
                     new Parm("@DepartmentId", SqlDbType.Int, departmentId)
                     };

               
                int affectedRows = db.ExecuteNonQuery("spDeleteDepartment", parms);

                if (affectedRows == 0)
                {
                    throw new InvalidOperationException("The department has employees associated with it. The department cannot be deleted.");
                }

                return affectedRows > 0;
            }            
            catch (Exception ex)
            {
               
                throw new ApplicationException(ex.Message);
            }
        }


        #endregion


        #region Private Methods

        private DepartmentDTO PopulateDepartmentDTO(DataRow row)
        {

            int id = Convert.ToInt32(row["DepartmentId"]);

            string name = row["DepartmentName"].ToString();

            DepartmentDTO department = new DepartmentDTO(id, name);

            return department;
        }

        private Department PopulateDepartment(DataRow row)
        {
            Department department = new Department();

            department.Id = Convert.ToInt32(row["DepartmentId"]);
            department.Name = Convert.ToString(row["DepartmentName"]);
            department.Description = Convert.ToString(row["Description"]);
            department.InvocationDate = Convert.ToDateTime(row["InvocationDate"]);
            department.RecordVersion = (byte[])row["RecordVersion"];

            return department;
        }

        #endregion

    }
}
