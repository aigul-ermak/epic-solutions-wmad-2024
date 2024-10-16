using DAL;
using EpicSolutions.Model;
using EpicSolutions.Types;
using Microsoft.Data.SqlClient;
using System.Data;


namespace EpicSolutions.Repo
{
    public class EmployeeRepo
    {

        #region Private Fields

        private readonly DataAccess db = new();

        #endregion


        #region Public Methods

        /// <summary>
        /// Adds a new employee to the system and returns the added employee.
        /// </summary>
        /// <param name="emp"></param>
        /// <returns></returns>
        /// <exception cref="DataException"></exception>
        public Employee AddEmployee(Employee emp)
        {
            List<Parm> parms = new()
            {
                new Parm("@EmployeeId", SqlDbType.Int, null, 0, ParameterDirection.Output),
                new Parm("@RecordVersion", SqlDbType.Timestamp, null, 0, ParameterDirection.Output),
                new Parm("@FirstName", SqlDbType.NVarChar, emp.FirstName, 50),
                new Parm("@MiddleInitial", SqlDbType.NVarChar, (object)emp.MiddleInitial ?? DBNull.Value, 1),
                new Parm("@LastName", SqlDbType.NVarChar, emp.LastName, 50),
                new Parm("@StreetAddress", SqlDbType.NVarChar, emp.StreetAddress, 255),
                new Parm("@City", SqlDbType.NVarChar, emp.City, 255),
                new Parm("@PostalCode", SqlDbType.NVarChar, emp.PostalCode, 7),
                new Parm("@DOB", SqlDbType.DateTime2, emp.DOB),
                new Parm("@SIN", SqlDbType.NVarChar, emp.SIN, 50),
                new Parm("@SeniorityDate", SqlDbType.DateTime2, emp.SeniorityDate),
                new Parm("@TerminationDate", SqlDbType.DateTime2, (object)emp.TerminationDate ?? DBNull.Value),
                new Parm("@JobStartDate", SqlDbType.DateTime2, (object)emp.JobStartDate ?? DBNull.Value),
                new Parm("@SupervisorEmployee", SqlDbType.Int, (object)emp.SupervisorEmployeeId ?? DBNull.Value),
                new Parm("@OfficeLocation", SqlDbType.NVarChar, emp.OfficeLocation, 255),
                new Parm("@WorkPhone", SqlDbType.NVarChar, emp.WorkPhone, 14),
                new Parm("@CellPhone", SqlDbType.NVarChar, emp.CellPhone, 14),
                new Parm("@Email", SqlDbType.NVarChar, emp.Email, 255),
                new Parm("@Password", SqlDbType.Char, emp.HashedPassword, 64),
                new Parm("@PasswordSalt",  SqlDbType.Binary, emp.PasswordSalt),
                new Parm("@isSupervisor", SqlDbType.Bit, emp.IsSupervisor),
                new Parm("@DepartmentId", SqlDbType.Int, (object)emp.DepartmentId ?? DBNull.Value),
                new Parm("@PositionId", SqlDbType.Int, emp.JobAssignmentId),
                new Parm("@StatusId", SqlDbType.Int, emp.StatusId),
                new Parm("@RoleId", SqlDbType.Int, (object)emp.RoleId ?? DBNull.Value)
            };

            if (db.ExecuteNonQuery("spAddEmployee", parms) > 0)
            {
                emp.Id = (int?)parms.FirstOrDefault(p => p.Name == "@EmployeeId")?.Value ?? 0;
                emp.RecordVersion = (byte[]?)parms.FirstOrDefault(p => p.Name == "@RecordVersion")?.Value;
            }
            else
            {
                throw new DataException("There was an error adding the employee.");
            }

            //if (db.ExecuteNonQuery("spAddEmployee", parms) == 0)
            //{
            //    throw new DataException("There error with add user");
            //}

            return emp;
        }



        /// <summary>
        /// Asynchronously retrieves a list of all active employees from the database.
        /// </summary>
        /// <returns>
        ///  task that represents the asynchronous operation, containing a list of EmployeeListDTO objects
        /// with data for all active employees retrieved from the database.
        /// </returns>
        public async Task<List<EmployeeListDTO>> GetAllEmployeesAsync()
        {
            //List<Parm> parms = new()
            //{
            //    new Parm("@UserId", SqlDbType.Int, userId)
            //};

            DataTable dt = await db.ExecuteAsync("spGetAllActiveEmployees");

            return dt.AsEnumerable().Select(row => PopulateEmployeeDTO(row)).ToList();
        }

        public async Task<EmployeeDetailDTO> GetEmployeeDetailAsync(string employeeNumber)
        {

            List<Parm> parms = new()
            {
                new Parm("@EmployeeNumber", SqlDbType.NVarChar, employeeNumber)
            };

            DataTable dt = await db.ExecuteAsync("spGetEmployeeDetailAsync", parms);

            if (dt.Rows.Count == 0)
            {
                return null;
            }

            DataRow row = dt.Rows[0];

            EmployeeDetailDTO employee = new EmployeeDetailDTO(
             row["FirstName"].ToString(),
             row["MiddleInitial"].ToString(),
             row["LastName"].ToString(),
             row["HomeMailingAddress"].ToString(),
             row["WorkPhone"].ToString(),
             row["CellPhone"].ToString(),
             row["Email"].ToString()
            );


            return employee;
        }

        public List<EmployeeListDTO> GetAllEmployees()
        {

            DataTable dt = db.Execute("spGetAllEmployees");

            return dt.AsEnumerable().Select(row => PopulateEmployeeDTO(row)).ToList();

        }

        public async Task<List<EmployeeMobileListDTO>> spGetAllMobileListEmployees()
        {
            List<EmployeeMobileListDTO> employees = new List<EmployeeMobileListDTO>();

            try
            {
                DataTable dt = await db.ExecuteAsync("spGetAllMobileListEmployees");

                if (dt.Rows.Count == 0)
                {
                    return employees;
                }

                foreach (DataRow row in dt.Rows)
                {
                    employees.Add(PopulateEmployeeMobileListDTOFromDataRow(row));
                }
            }
            catch (Exception ex)
            {
                throw new ApplicationException("An error occurred while fetching employees", ex);
            }

            return employees;
        }

        public async Task<EmployeeAreaDTO> GetEmployeeInfo(int employeeId)
        {
            List<Parm> parms = new()
            {
                new Parm("@EmployeeId", SqlDbType.Int, employeeId),

            };

            DataTable dt = await db.ExecuteAsync("spGetEmployeeInfo", parms);

            if (dt.Rows.Count == 0)
            {

                throw new Exception($"Employee with ID {employeeId} not found.");
            }

            DataRow row = dt.Rows[0];

            return PopulateEmployeeAreDTOFromDataRow(row);

        }

        public string GetSinByEmployeeId(int employeeId)
        {
            string sin = "";

            List<Parm> parms = new()
            {
                new Parm("@EmployeeId", SqlDbType.Int, employeeId),

            };

            DataTable dt = db.Execute("spGetSinByEmployeeId", parms);

            if (dt.Rows.Count > 0)
            {

                sin = Convert.ToString(dt.Rows[0]["SIN"]);
            }

            return sin;

        }


        public int IsSupervisorChanged(Employee emp)
        {
           
            List<Parm> parms = new()
            {
                new Parm("@EmployeeId", SqlDbType.Int, emp.Id),

            };

            DataTable dt = db.Execute("spIsSupervisorChanged", parms);

            int supervisorId = Convert.ToInt32(dt.Rows[0]["SupervisorEmployee"]); ;

            return supervisorId;

        }


        public async Task<List<EmployeeMobileListDTO>> GetAllEmployeesByDepartmentId(int departmentId)
        {
            List<Parm> parms = new()
            {
                new Parm("@DepartmentId", SqlDbType.Int, departmentId),

            };

            DataTable dt = await db.ExecuteAsync("spGetAllEmployeesByDepartmentId", parms);
            List<EmployeeMobileListDTO> employees = new List<EmployeeMobileListDTO>();

            if (dt.Rows.Count == 0)
            {

                return employees;
            }

            foreach (DataRow row in dt.Rows)
            {
                employees.Add(PopulateEmployeeMobileListDTOFromDataRow(row));
            }

            return employees;

        }

        public async Task<List<EmployeeMobileListDTO>> GetAllEmployeesByEmployeeNumber(string employeeNumber)
        {
            List<Parm> parms = new()
            {
                new Parm("@EmployeeNumber", SqlDbType.NVarChar, employeeNumber, 8),

            };

            DataTable dt = await db.ExecuteAsync("spGetAllEmployeesByEmployeeNumber", parms);
            List<EmployeeMobileListDTO> employees = new List<EmployeeMobileListDTO>();

            if (dt.Rows.Count == 0)
            {

                return employees;
            }

            foreach (DataRow row in dt.Rows)
            {
                employees.Add(PopulateEmployeeMobileListDTOFromDataRow(row));
            }

            return employees;

        }

        public async Task<List<EmployeeMobileListDTO>> GetAllEmployeesByEmployeeLastName(string lastName)
        {
            List<Parm> parms = new()
            {
                new Parm("@LastName", SqlDbType.NVarChar, lastName, 50),

            };

            DataTable dt = await db.ExecuteAsync("spGetAllEmployeesByEmployeeLastName", parms);
            List<EmployeeMobileListDTO> employees = new List<EmployeeMobileListDTO>();

            if (dt.Rows.Count == 0)
            {

                return employees;
            }

            foreach (DataRow row in dt.Rows)
            {
                employees.Add(PopulateEmployeeMobileListDTOFromDataRow(row));
            }

            return employees;

        }

        public async Task<List<EmployeeMobileListDTO>> SearchEmployeesMobileListDepartmentIdAndByEmployeeNumber(int departmentId, string employeeNumber)
        {
            List<Parm> parms = new()
            {
                new Parm("@DepartmentId", SqlDbType.Int, departmentId),
                new Parm("@EmployeeNumber", SqlDbType.NVarChar, employeeNumber, 8),

            };

            DataTable dt = await db.ExecuteAsync("spSearchEmployeesMobileListDepartmentIdAndByEmployeeNumber", parms);
            List<EmployeeMobileListDTO> employees = new List<EmployeeMobileListDTO>();

            if (dt.Rows.Count == 0)
            {

                return employees;
            }

            foreach (DataRow row in dt.Rows)
            {
                employees.Add(PopulateEmployeeMobileListDTOFromDataRow(row));
            }

            return employees;

        }

        public async Task<List<EmployeeMobileListDTO>> SearchEmployeesMobileListDepartmentIdAndByLastName(int departmentId, string lastName)
        {
            List<Parm> parms = new()
            {
                new Parm("@DepartmentId", SqlDbType.Int, departmentId),
                new Parm("@LastName", SqlDbType.NVarChar, lastName, 50),

            };

            DataTable dt = await db.ExecuteAsync("spSearchEmployeesMobileListDepartmentIdAndByLastName", parms);
            List<EmployeeMobileListDTO> employees = new List<EmployeeMobileListDTO>();

            if (dt.Rows.Count == 0)
            {

                return employees;
            }

            foreach (DataRow row in dt.Rows)
            {
                employees.Add(PopulateEmployeeMobileListDTOFromDataRow(row));
            }

            return employees;

        }

        public EmployeePasswordDTO GetEmployeePersonalPasswordDTO(int employeeId)
        {
            List<Parm> parms = new()
            {
                new Parm("@EmployeeId", SqlDbType.Int, employeeId)
            };

            DataTable dt = db.Execute("spGetEmployeePersonalPasswordDTO", parms);

            if (dt.Rows.Count == 0)
            {

                throw new Exception($"Employee with ID {employeeId} not found.");
            }

            DataRow row = dt.Rows[0];

            EmployeePasswordDTO emp = new EmployeePasswordDTO()
            {
                Id = Convert.ToInt32(row["EmployeeId"]),
                EmployeeNumber = row["EmployeeNumber"].ToString(),
                RecordVersion = row["RecordVersion"] == DBNull.Value ? null : (byte[])row["RecordVersion"]

        };

            return emp;

        }

        public EmployeePersonalDTO GetEmployeePersonal(int employeeId)
        {
            List<Parm> parms = new()
            {
                new Parm("@EmployeeId", SqlDbType.Int, employeeId),

            };

            DataTable dt = db.Execute("spGetEmployeePersonal", parms);

            if (dt.Rows.Count == 0)
            {

                throw new Exception($"Employee with ID {employeeId} not found.");
            }

            DataRow row = dt.Rows[0];

            return PopulateEmployeePersonalDTO(row);

        }



        /// <summary>
        /// Searches for employees based on their employee number and last name.
        /// </summary>
        /// <param name="employeeNumber"></param>
        /// <param name="lastName"></param>
        /// <returns>
        /// A task representing the asynchronous operation. The task result contains a list of objects representing employees that match the given criteria.
        /// </returns>
        public async Task<List<EmployeeListDTO>> SearchEmployeesByLastNameByEmpNumber(string employeeNumber, string lastName)
        {
            List<Parm> parms = new()
            {
                new Parm("@EmployeeNumber", SqlDbType.NVarChar, string.IsNullOrEmpty(employeeNumber) ? DBNull.Value : (object)employeeNumber, 8),
                new Parm("@LastName", SqlDbType.NVarChar, string.IsNullOrEmpty(lastName) ? DBNull.Value : (object)lastName, 50)
            };

            DataTable dt = await db.ExecuteAsync("spSearchEmployeesByLastNameByEmpNumber", parms);

            return dt.AsEnumerable().Select(row => PopulateEmployeeDTO(row)).ToList();
        }

        public bool UpdateEmployeePersonal(Employee emp)
        {
            try
            {
                List<Parm> parms = new()
        {
            new Parm("@RecordVersion", SqlDbType.Timestamp, emp.RecordVersion, 0, ParameterDirection.Input),
            new Parm("@EmployeeId", SqlDbType.Int, emp.Id),
            new Parm("@StreetAddress", SqlDbType.NVarChar, emp.StreetAddress, 255),
            new Parm("@City", SqlDbType.NVarChar, emp.City, 255),
            new Parm("@PostalCode", SqlDbType.NVarChar, emp.PostalCode, 7),
            new Parm("@NewRecordVersion", SqlDbType.Timestamp, null, 0, ParameterDirection.Output)
        };

                int rowsAffected = db.ExecuteNonQuery("spUpdateEmployeePersonal", parms);

                if(rowsAffected > 0)
        {
                    emp.RecordVersion = (byte[]?)parms.FirstOrDefault(p => p.Name == "@NewRecordVersion")?.Value;
                    return true;
                }
                return false;
            }
            catch (SqlException ex) when (ex.Number == 51002)
            {
                throw new InvalidOperationException("The Employee has been updated by another user. Please refresh and try again.", ex);
            }
            catch (Exception ex)
            {
                throw new DataException("Error updating department.", ex);
            }
        }

        public async Task<Employee> UpdateEmployeeInfo(Employee emp)
        {
            try
            {
                List<Parm> parms = new()
        {
                new Parm("@RecordVersion", SqlDbType.Timestamp, emp.RecordVersion, 0, ParameterDirection.Input),
                new Parm("@EmployeeId", SqlDbType.Int, emp.Id),
                new Parm("@FirstName", SqlDbType.NVarChar, emp.FirstName, 50),
                new Parm("@MiddleInitial", SqlDbType.NVarChar, (object)emp.MiddleInitial ?? DBNull.Value, 1),
                new Parm("@LastName", SqlDbType.NVarChar, emp.LastName, 50),
                new Parm("@StreetAddress", SqlDbType.NVarChar, emp.StreetAddress, 255),
                new Parm("@City", SqlDbType.NVarChar, emp.City, 255),
                new Parm("@PostalCode", SqlDbType.NVarChar, emp.PostalCode, 7),
                new Parm("@DOB", SqlDbType.DateTime2, emp.DOB),
                new Parm("@SIN", SqlDbType.NVarChar, emp.SIN, 50),
                new Parm("@SeniorityDate", SqlDbType.DateTime2, emp.SeniorityDate),
                new Parm("@JobStartDate", SqlDbType.DateTime2, (object)emp.JobStartDate ?? DBNull.Value),
                new Parm("@RetirementDate", SqlDbType.DateTime2, (object)emp.RetirementDate ?? DBNull.Value),
                new Parm("@TerminationDate", SqlDbType.DateTime2, (object)emp.TerminationDate ?? DBNull.Value),
                new Parm("@SupervisorEmployee", SqlDbType.Int, emp.SupervisorEmployeeId),
                new Parm("@WorkPhone", SqlDbType.NVarChar, emp.WorkPhone, 14),
                new Parm("@CellPhone", SqlDbType.NVarChar, emp.CellPhone, 14),
                new Parm("@Email", SqlDbType.NVarChar, emp.Email, 255),
                new Parm("@DepartmentId", SqlDbType.Int, emp.DepartmentId),
                new Parm("@PositionId", SqlDbType.Int, emp.JobAssignmentId),
                new Parm("@StatusId", SqlDbType.Int, emp.StatusId),
                new Parm("@NewRecordVersion", SqlDbType.Timestamp, null, 0, ParameterDirection.Output)
        };


                int rowsAffected =  await db.ExecuteNonQueryAsync("spUpdateEmployeeInfo", parms);

                if (rowsAffected > 0)
                {
                    emp.RecordVersion = (byte[]?)parms.FirstOrDefault(p => p.Name == "@NewRecordVersion")?.Value;
                    return emp;
                }
                else
                {
                    throw new InvalidOperationException("No changes were made to the Employee record. This may be due to no changes in data or concurrent updates.");
                }
               
            }
            catch (SqlException ex) when (ex.Number == 51002)
            {
                throw new InvalidOperationException("The Employee has been updated by another user. Please refresh and try again.", ex);
            }
            catch (Exception ex)
            {
                throw new DataException("Error updating department.", ex);
            }

        }

        public bool UpdateEmployeePersonalPassword(Employee emp)
        {
            try
            {
                List<Parm> parms = new()
                {
                new Parm("@RecordVersion", SqlDbType.Timestamp, emp.RecordVersion, 0,  ParameterDirection.Input),
                new Parm("@EmployeeId", SqlDbType.Int, emp.Id),
                new Parm("@Password", SqlDbType.Char, emp.HashedPassword, 64),
                new Parm("@PasswordSalt",  SqlDbType.Binary, emp.PasswordSalt),
                new Parm("@NewRecordVersion", SqlDbType.Timestamp, null, 0, ParameterDirection.Output)
                };

                int rowsAffected = db.ExecuteNonQuery("spUpdateEmployeePersonalPassword", parms);

                //return rowsAffected > 0;
                if (rowsAffected > 0)
                {
                    emp.RecordVersion = (byte[]?)parms.FirstOrDefault(p => p.Name == "@NewRecordVersion")?.Value;
                    return true;
                }
                else
                {
                    throw new InvalidOperationException("No changes were made to the Employee record. This may be due to no changes in data or concurrent updates.");
                }

            }
            catch (SqlException ex) when (ex.Number == 51002)
            {
                throw new InvalidOperationException("The Employee has been updated by another user. Please refresh and try again.", ex);
            }
            catch (Exception ex)
            {
                throw new DataException("Error updating department.", ex);
            }
        }

        /// <summary>
        /// Searches for employees based on their department name, employee number, and last name.
        /// </summary>
        /// <param name="departmentName"></param>
        /// <param name="employeeNumber"></param>
        /// <param name="lastName"></param>
        /// <returns>
        /// A task representing the asynchronous operation. The task result contains a list of objects representing employees that match the given criteria.
        /// </returns>
        public async Task<List<EmployeeListDTO>> SearchEmployeesByLastNameByEmpNumberByDepartmentName(string departmentName, string employeeNumber, string lastName)
        {
            List<Parm> parms = new()
            {
                new Parm("@DepartmentName", SqlDbType.NVarChar, departmentName, 128),
                new Parm("@EmployeeNumber", SqlDbType.NVarChar, employeeNumber, 8),
                new Parm("@LastName", SqlDbType.NVarChar, lastName, 50)
            };

            DataTable dt = await db.ExecuteAsync("spSearchEmployeesByLastNameByEmpNumberByDepartmentName", parms);

            return dt.AsEnumerable().Select(row => PopulateEmployeeDTO(row)).ToList();
        }

        public async Task<List<EmployeeMobileListDTO>> SearchEmployeesMobileListByLastNameByEmpNumberByDepartmentId(string departmentId, string employeeNumber, string lastName)
        {
            List<Parm> parms = new()
            {
                new Parm("@DepartmentId", SqlDbType.Int, departmentId),
                new Parm("@EmployeeNumber", SqlDbType.NVarChar, employeeNumber, 8),
                new Parm("@LastName", SqlDbType.NVarChar, lastName, 50)
            };

            DataTable dt = await db.ExecuteAsync("spSearchEmployeesMobileListByLastNameByEmpNumberByDepartmentId", parms);

            return dt.AsEnumerable().Select(row => PopulateEmployeeMobileListDTOFromDataRow(row)).ToList();
        }

        /// <summary>
        /// Searches for all active employees by their department name.
        /// </summary>
        /// <param name="departmentName"></param>
        /// <returns>
        /// A task representing the asynchronous operation. The task result contains a list of objects representing active employees that belong to the specified department.
        /// </returns>
        public async Task<List<EmployeeListDTO>> SearchEmployeesByActiveDepartmentNameAsync(string departmentName)
        {
            List<Parm> parms = new()
            {
                new Parm("@DepartmentName", SqlDbType.NVarChar, departmentName, 128)
            };

            DataTable dt = await db.ExecuteAsync("spSearchEmployeesByActiveDepartment", parms);

            return dt.AsEnumerable().Select(row => PopulateEmployeeDTO(row)).ToList();
        }

        /// <summary>
        /// Searches for employees by their employee number.
        /// </summary>
        /// <param name="employeeNumber"></param>
        /// <returns>
        /// A task representing the asynchronous operation. The task result contains a list of objects representing employees matching the specified employee number.
        /// </returns>
        public async Task<List<EmployeeListDTO>> SearchEmployeesByEmployeeNumberAsync(string employeeNumber)
        {
            List<Parm> parms = new()
            {
                new Parm("@EmployeeNumber", SqlDbType.NVarChar, employeeNumber, 8)
            };

            DataTable dt = await db.ExecuteAsync("spSearchEmployeesByEmployeeNumber", parms);

            return dt.AsEnumerable().Select(row => PopulateEmployeeDTO(row)).ToList();
        }

        /// <summary>
        ///  Searches for employees by their last name.
        /// </summary>
        /// <param name="lastName"></param>
        /// <returns>
        /// A task representing the asynchronous operation. The task result contains a list of objects representing employees matching the specified last name.
        /// </returns>
        public async Task<List<EmployeeListDTO>> SearchEmployeesByLastNameAsync(string lastName)
        {
            List<Parm> parms = new()
            {
                new Parm("@LastName", SqlDbType.NVarChar, lastName, 50)
            };

            DataTable dt = await db.ExecuteAsync("spSearchEmployeesByLastName", parms);

            return dt.AsEnumerable().Select(row => PopulateEmployeeDTO(row)).ToList();
        }

        /// <summary>
        /// Checks if a given Social Insurance Number (SIN) is unique.
        /// </summary>
        /// <param name="sin"></param>
        /// <returns>true or false</returns>
        public bool IsSinUnique(string sin)
        {
            List<Parm> parms = new()
            {
                new Parm("@SIN", SqlDbType.NVarChar, sin, 50)
            };

            DataTable dt = db.Execute("spIsSinUnique", parms);

            return dt.Rows.Count == 0;
        }

        /// <summary>
        /// Determines whether a given supervisor ID is valid.
        /// </summary>
        /// <param name="supervisorId"></param>
        /// <returns>true or false</returns>
        public int SupervisorDepartment(int supervisorId)
        {

            List<Parm> parms = new()
            {

                new Parm("@SupervisorId", SqlDbType.NVarChar, supervisorId)
            };

            int departmentId = (int)db.ExecuteScalar("spSupervisorDepartment", parms);

            return departmentId;
        }

        public bool IsSupervisorValid(int supervisorId)
        {
            List<Parm> parms = new()
            {
                new Parm("@SupervisorId", SqlDbType.NVarChar, supervisorId)
            };

            DataTable dt = db.Execute("spIsSupervisorValid", parms);


            if (dt.Rows.Count > 0)
            {
                int count = Convert.ToInt32(dt.Rows[0][0]);
                return count < 10;
            }

            return true;
        }




        public int IsSupervisorDepartmentValid(int supervisorId)
        {
            List<Parm> parms = new()
            {
                new Parm("@SupervisorId", SqlDbType.NVarChar, supervisorId)
            };

            int departmentId = (int)db.ExecuteScalar("spIsSupervisorDepartmentValid", parms);


            return departmentId;
        }

        public EmployeeDTO GetEmployeeDTO(int employeeId)
        {
            List<Parm> parms = new()
            {
                new Parm("@EmployeeId", SqlDbType.Int, employeeId)
            };

            DataTable dt = db.Execute("spGetEmployeeDTO", parms);

            if (dt != null && dt.Rows.Count > 0)
            {
                DataRow row = dt.Rows[0];

                EmployeeDTO employee = new EmployeeDTO
                {
                    Id = Convert.ToInt32(row["EmployeeId"]),
                    FirstName = row["FirstName"] as string,
                    LastName = row["LastName"] as string,
                    Email = row["Email"] as string,
                    WorkPhone = row["WorkPhone"] as string,
                    DateHired = row["SeniorityDate"] as DateTime?,
                    Position = row["Position"] as string,
                    Department = row["Department"] as string
                };

                return employee;
            }
            else
            {
                return null;
            }

        }

        public Employee GetEmployee(int employeeId)
        {
            List<Parm> parms = new()
            {
                new Parm("@EmployeeId", SqlDbType.Int, employeeId)
            };

            DataTable dt = db.Execute("spGetEmployee", parms);


            if (dt.Rows.Count == 0)
            {

                throw new Exception($"Employee with ID {employeeId} not found.");
            }

            DataRow row = dt.Rows[0];

            return PopulateEmployeeFromDataRow(row);

        }


        public int GetEmployeeBySupervisor(int supervisorId)
        {
            List<Parm> parms = new()
            {
                new Parm("@SupervisorId", SqlDbType.Int, supervisorId)
            };

            return Convert.ToInt32(db.ExecuteScalar("spGetEmployeeBySupervisorId", parms));

        }

        #endregion


        #region Private Methods

        /// <summary>
        /// Converts a DataRow object into an EmployeeListDTO object.
        /// </summary>
        /// <param name="row"></param>
        /// <returns>
        /// An EmployeeListDTO instance representing the employee details extracted from the given DataRow.
        /// </returns>
        private EmployeeListDTO PopulateEmployeeDTO(DataRow row)
        {

            int employeeId = Convert.ToInt32(row["EmployeeId"]);
            string employeeNumber = row["EmployeeNumber"].ToString();
            string lastName = row["LastName"].ToString();
            string firstName = row["FirstName"].ToString();
            string workPhone = row["WorkPhone"].ToString();
            string officeLocation = row["OfficeLocation"].ToString();
            string position = row["Position"].ToString();

            EmployeeListDTO employee = new EmployeeListDTO(employeeId, employeeNumber, lastName, firstName, workPhone, officeLocation, position);

            return employee;
        }

        private EmployeePersonalDTO PopulateEmployeePersonalDTO(DataRow row)
        {
            int employeeId = Convert.ToInt32(row["EmployeeId"]);
            string employeeNumber = row["EmployeeNumber"].ToString();
            string firstName = row["FirstName"].ToString();
            string middleInitial = row["MiddleInitial"].ToString();
            string lastName = row["LastName"].ToString();
            string streetAddress = row["StreetAddress"].ToString();
            string city = row["City"].ToString();
            string postalCode = row["PostalCode"].ToString();

            byte[] recordVersion = row["RecordVersion"] == DBNull.Value ? null : (byte[])row["RecordVersion"];

            return new EmployeePersonalDTO
            {
                Id = employeeId,
                EmployeeNumber = employeeNumber,
                FirstName = firstName,
                MiddleInitial = middleInitial,
                LastName = lastName,
                StreetAddress = streetAddress,
                City = city,
                PostalCode = postalCode,
                RecordVersion = recordVersion
            };
        }


        private Employee PopulateEmployeeFromDataRow(DataRow row)
        {
            try
            {
                Employee employee = new Employee
                {
                    Id = Convert.ToInt32(row["EmployeeId"] ?? 0),
                    EmployeeNumber = row["EmployeeNumber"]?.ToString(),
                    FirstName = row["FirstName"]?.ToString(),
                    MiddleInitial = row["MiddleInitial"]?.ToString(),
                    LastName = row["LastName"]?.ToString(),
                    StreetAddress = row["StreetAddress"]?.ToString(),
                    City = row["City"]?.ToString(),
                    PostalCode = row["PostalCode"]?.ToString(),
                    DOB = row["DOB"] as DateTime?,
                    SIN = row["SIN"]?.ToString(),
                    SeniorityDate = Convert.ToDateTime(row["SeniorityDate"] ?? DateTime.Today),
                    RetirementDate = row["RetirementDate"] as DateTime?,
                    TerminationDate = row["TerminationDate"] as DateTime?,
                    JobStartDate = row["JobStartDate"] as DateTime?,
                    WorkPhone = row["WorkPhone"]?.ToString(),
                    CellPhone = row["CellPhone"]?.ToString(),
                    Email = row["Email"]?.ToString(),
                    DepartmentId = Convert.ToInt32(row["DepartmentId"] ?? 0),
                    JobAssignmentId = Convert.ToInt32(row["PositionId"] ?? 0),
                    SupervisorEmployeeId = Convert.ToInt32(row["SupervisorEmployee"] ?? 0),
                    RoleId = Convert.ToInt32(row["RoleId"] ?? 0),
                    StatusId = Convert.ToInt32(row["StatusId"] ?? 1)
                };

                return employee;
            }
            catch (Exception ex)
            {
                throw new Exception("An error occurred while populating the Employee object", ex);
            }
        }

        private EmployeeAreaDTO PopulateEmployeeAreDTOFromDataRow(DataRow row)
        {
            try
            {
                EmployeeAreaDTO employee = new EmployeeAreaDTO
                {
                    Id = Convert.ToInt32(row["EmployeeId"] ?? 0),
                    EmployeeNumber = row["EmployeeNumber"]?.ToString(),
                    FirstName = row["FirstName"]?.ToString(),
                    MiddleInitial = row["MiddleInitial"]?.ToString(),
                    LastName = row["LastName"]?.ToString(),
                    StreetAddress = row["StreetAddress"]?.ToString(),
                    City = row["City"]?.ToString(),
                    PostalCode = row["PostalCode"]?.ToString(),
                    DOB = row["DOB"] as DateTime?,
                    SIN = row["SIN"]?.ToString(),
                    SeniorityDate = Convert.ToDateTime(row["SeniorityDate"] ?? DateTime.Today),
                    RetirementDate = row["RetirementDate"] as DateTime?,
                    TerminationDate = row["TerminationDate"] as DateTime?,
                    JobStartDate = row["JobStartDate"] as DateTime?,
                    WorkPhone = row["WorkPhone"]?.ToString(),
                    CellPhone = row["CellPhone"]?.ToString(),
                    Email = row["Email"]?.ToString(),
                    DepartmentId = Convert.ToInt32(row["DepartmentId"] ?? 0),
                    JobAssignmentId = Convert.ToInt32(row["PositionId"] ?? 0),
                    SupervisorEmployeeId = Convert.ToInt32(row["SupervisorEmployee"] ?? 0),
                    StatusId = Convert.ToInt32(row["StatusId"] ?? 0),
                    RecordVersion = row["RecordVersion"] == DBNull.Value ? null : (byte[])row["RecordVersion"]
            };

                return employee;
            }
            catch (Exception ex)
            {
                throw new Exception("An error occurred while populating the Employee object", ex);
            }
        }

        private EmployeeMobileListDTO PopulateEmployeeMobileListDTOFromDataRow(DataRow row)
        {
            try
            {
                string employeeNumber = row["EmployeeNumber"]?.ToString();
                string lastName = row["LastName"]?.ToString();
                string firstName = row["FirstName"]?.ToString();
                string position = row["Position"]?.ToString();

                EmployeeMobileListDTO employee = new EmployeeMobileListDTO(
                    employeeNumber,
                    lastName ?? "",
                    firstName ?? "",
                    position ?? ""
                    );


                return employee;
            }
            catch (Exception ex)
            {
                throw new Exception("An error occurred while populating the Employee object", ex);
            }
        }


        #endregion
    }
}
