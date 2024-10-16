using DAL;
using EpicSolutions.Model;
using EpicSolutions.Types;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EpicSolutions.Repo
{
    public class ListsRepo
    {
        #region Fields

        private readonly DataAccess db = new();

        #endregion


        #region Public Methods

        public List<DepartmentDTO> GetDepartmentList()
        {
            DataTable dt = db.Execute("spGetDepartments");

            return dt.AsEnumerable().Select(row =>
                new DepartmentDTO((int)row["DepartmentId"], row["DepartmentName"].ToString()!)).ToList();
        }

        public List<SupervisorEmployee> GetSupervisorList()
        {
            DataTable dt = db.Execute("spSupervisorEmployeeList");

            return dt.AsEnumerable().Select(row =>
                new SupervisorEmployee(
                    (int)row["EmployeeId"], 
                    row["Name"].ToString()!,
                    string.IsNullOrEmpty(row["Department"].ToString()) ? "CEO" : row["Department"].ToString()
                    )
                ).ToList();
        }
               

        public List<DepartmentDTO> GetDepartmentListById(int id)
        {
            List<Parm> parms = new()
{
            new Parm("@PositionId", SqlDbType.Int, id)
            };

            DataTable dt = db.Execute("spGetDepartmentByPositionId", parms);

            return dt.AsEnumerable().Select(row =>
                new DepartmentDTO((int)row["DepartmentId"], row["DepartmentName"].ToString()!)).ToList();
        }

        public List<PositionListDTO> GetJobAssignmentList()
        {
            DataTable dt = db.Execute("spGetJobAssignments");

            return dt.AsEnumerable().Select(row =>
                new PositionListDTO((int)row["PositionId"], row["PositionName"].ToString()!)).ToList();
        }

        public async Task<List<PositionListDTO>> GetAllPositionsAsync()
        {

            DataTable dt = await db.ExecuteAsync("spGetAllPositions");

            return dt.AsEnumerable().Select(row => PopulatePositionDTO(row)).ToList();
        }

        public List<RatingDTO> GetRatingList()
        {

            DataTable dt = db.Execute("spGetRatingList");

            return dt.AsEnumerable().Select(row =>
                new RatingDTO((int)row["RatingId"], row["RatingName"].ToString()!)).ToList();
        }

        public List<QuarterDTO> GetQuartersList()
        {

            DataTable dt = db.Execute("spGetQuatersList");

            return dt.AsEnumerable().Select(row =>
                new QuarterDTO((int)row["QuarterId"], row["QuarterName"].ToString()!)).ToList();
        }

        public List<SupervisorEmployeeDTO> GetSupervisorsByIdsList(int roleId, int departmentId)
        {

            List<Parm> parms = new()
{
            new Parm("@RoleId", SqlDbType.Int, roleId),
            new Parm("@DepartmentId", SqlDbType.Int, departmentId)
            };

            DataTable dt = db.Execute("spGetSupervisorByRoleIdDepartmentId", parms);

            return dt.AsEnumerable().Select(row =>
                new SupervisorEmployeeDTO((int)row["EmployeeId"], row["FullName"].ToString()!)).ToList();
        }

        public List<SupervisorEmployeeDTO> GetSupervisorsByPositionId(int positionId)
        {

            List<Parm> parms = new()
            {
           
            new Parm("@PositionId", SqlDbType.Int, positionId)
            };

            DataTable dt = db.Execute("spGetSupervisorByPositionId", parms);

            return dt.AsEnumerable().Select(row =>
                new SupervisorEmployeeDTO((int)row["EmployeeId"], row["FullName"].ToString()!)).ToList();
        }
        public List<SupervisorEmployeeDTO> GetSupervisorEmployeeList()
        {
            DataTable dt = db.Execute("spGetSupervisorEmployees");

            return dt.AsEnumerable().Select(row =>
                new SupervisorEmployeeDTO((int)row["EmployeeId"], row["FullName"].ToString()!)).ToList();
        }


        public List<RoleDTO> GetRolesList(int id)
        {

            List<Parm> parms = new()
{
            new Parm("@PositionId", SqlDbType.Int, id)
            };

            DataTable dt = db.Execute("spGetRoleByPositionId", parms);

            return dt.AsEnumerable().Select(row =>
                new RoleDTO((int)row["RoleId"], row["RoleName"].ToString()!)).ToList();
        }

        public List<RoleDTO> GetRolesList()
        {

            DataTable dt = db.Execute("spGetRolesList");

            return dt.AsEnumerable().Select(row =>
                new RoleDTO((int)row["RoleId"], row["RoleName"].ToString()!)).ToList();
        }

        public List<Status> GetStatusList()
        {
            DataTable dt = db.Execute("spGetStatus");

            return dt.AsEnumerable().Select(row =>
                new Status
                {
                    StatusId = Convert.ToInt32(row["StatusId"]),
                    StatusName = row["StatusName"].ToString()
                }).ToList();
        }

        public List<Status> GetEmployeeStatusList()
        {
            DataTable dt = db.Execute("spGetEmployeeStatus");

            return dt.AsEnumerable().Select(row =>
                new Status
                {
                    StatusId = Convert.ToInt32(row["StatusId"]),
                    StatusName = row["StatusName"].ToString()
                }).ToList();
        }

        public int GetOrderID(string OrderNumber)
        {

            List<Parm> parms = new()
            {
                new Parm("@OrderNumber", SqlDbType.NVarChar, OrderNumber)
            };

            int id = (int)db.ExecuteScalar("spGetOrderId", parms);

            return id;
        }

        #endregion


        #region Private Methods

        private PositionListDTO PopulatePositionDTO(DataRow row)
        {

            int id = Convert.ToInt32(row["PositionId"]);

            string name = row["PositionName"].ToString();

            PositionListDTO department = new PositionListDTO(id, name);

            return department;
        }

        #endregion
    }
}
