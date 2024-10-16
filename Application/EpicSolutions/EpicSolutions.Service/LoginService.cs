using EpicSolutions.Model;

using EpicSolutions.Repo;
using EpicSolutions.Types;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EpicSolutions.Service
{
    public class LoginService
    {

        #region Fields

        private readonly LoginRepo repo = new();

        #endregion

        #region  Public Methods

        public async Task<EmployeeUserDTO?> Login(LoginDTO user)
        {
            byte[] salt = repo.GetUserSalt(user.EmployeeNumber);

            if (salt == null)
                return null;

            if (string.IsNullOrEmpty(user.EmployeeNumber) || string.IsNullOrEmpty(user.Password))
                return null;

            user.Password = PasswordUtility.HashToSHA256(user.Password, salt);

            //if (!ValidateEmployeeUser(user)) 
            //    return null; 
            
            return await repo.Login(user);
            
        }

        #endregion

        public async Task<Boolean> ValidateRetirementStatus(string employeeNumber)
        {
            return await repo.IsRetirementStatus(employeeNumber);         

        }

        public async Task<Boolean> ValidateTerminationStatus(string employeeNumber)
        {
            return await repo.IsTerminationStatus(employeeNumber);
        }


        
    }
}
