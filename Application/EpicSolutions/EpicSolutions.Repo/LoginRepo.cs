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
    public class LoginRepo
    {

        private readonly DataAccess db = new();

        public byte[] GetUserSalt(string? employeeNumber)
        {
            List<Parm> parms = new()
        {
            new("@EmployeeNumber", SqlDbType.NVarChar, employeeNumber, 8),
        };

            string sql = "SELECT PasswordSalt FROM [Employee] WHERE EmployeeNumber = @EmployeeNumber";
            return (byte[])db.ExecuteScalar(sql, parms, CommandType.Text);

        }

        public async Task<EmployeeUserDTO?> Login(LoginDTO user)
        {
            DataTable dt = await db.ExecuteAsync("spLogin",
                new List<Parm>
                {
                new Parm("@EmployeeNumber", SqlDbType.NVarChar,user.EmployeeNumber, 8),
                new Parm("@HashedPassword", SqlDbType.NVarChar, user.Password, 255)
                });

            if (dt.Rows.Count == 0)
                return null;

            DataRow row = dt.Rows[0];

            return new EmployeeUserDTO
            {
                EmployeeId = Convert.ToInt32(row["EmployeeId"]),
                EmployeeNumber = row["EmployeeNumber"].ToString(),
                Email = row["Email"].ToString(),
                RoleName = row["RoleName"].ToString(),
                Department = row["DepartmentName"].ToString(),
                Supervisor = row["SupervisorEmp"].ToString(),
                EmployeeName = row["EmployeeName"].ToString()

            };
        }


        public async Task<Boolean> IsRetirementStatus(string employeeNumber)
        {
            DataTable dt = await db.ExecuteAsync("spIsRetirementStatus",
                new List<Parm>
                {
                new Parm("@EmployeeNumber", SqlDbType.NVarChar,employeeNumber, 8),                
                });

            bool hasRetirementStatus = dt.Rows.Count > 0;

            return hasRetirementStatus;
        }

        public async Task<Boolean> IsTerminationStatus(string employeeNumber)
        {
            DataTable dt = await db.ExecuteAsync("spIsTerminationStatus",
         new List<Parm>
         {
            new Parm("@EmployeeNumber", SqlDbType.NVarChar, employeeNumber.ToString(), 8),
         });
           
            bool hasTerminationStatus = dt.Rows.Count > 0;

            return hasTerminationStatus;

        }

    }
}
