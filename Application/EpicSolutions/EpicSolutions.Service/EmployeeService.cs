using EpicSolutions.Model;
using EpicSolutions.Repo;
using EpicSolutions.Types;
using System.ComponentModel.Design;


namespace EpicSolutions.Service
{
    public class EmployeeService
    {
        #region Private Fields

        private readonly EmployeeRepo repo = new();

        #endregion


        #region Public Methods

        public Employee AddEmployee(Employee emp)
        {

            if (ValidateEmployee(emp))
            {
                emp.PasswordSalt = PasswordUtility.GenerateSalt();
                emp.HashedPassword = PasswordUtility.HashToSHA256(emp.HashedPassword!, emp.PasswordSalt);


                return repo.AddEmployee(emp);
            }

            return emp;

        }

        public bool UpdateEmployeePersonalPassword(Employee emp)
        {

            emp.PasswordSalt = PasswordUtility.GenerateSalt();
            emp.HashedPassword = PasswordUtility.HashToSHA256(emp.HashedPassword!, emp.PasswordSalt);


            return repo.UpdateEmployeePersonalPassword(emp);

        }

        public async Task<Employee?> UpdateEmployeeInfoAsync(Employee emp)
        {
            if (emp.StatusId == 3)
            {
                await repo.UpdateEmployeeInfo(emp);

            }
            else if (ValidateUpdateEmployee(emp))
            {
                await repo.UpdateEmployeeInfo(emp);
            }
            return emp;

        }

        public async Task<EmployeeAreaDTO> GetEmployeeInfo(int employeeId)
        {
            return await repo.GetEmployeeInfo(employeeId);
        }


        public EmployeeDTO GetEmployeeDTO(int employeeId)
        {
            return repo.GetEmployeeDTO(employeeId);

        }
        public bool UpdateEmployeePersonal(Employee emp)
        {
            return repo.UpdateEmployeePersonal(emp);

        }

        public EmployeePasswordDTO GetEmployeePersonalPasswordDTO(int employeeId)
        {
            return repo.GetEmployeePersonalPasswordDTO(employeeId);

        }

        public Employee GetEmployee(int employeeId)
        {
            return repo.GetEmployee(employeeId);

        }

        public EmployeePersonalDTO GetEmployeePersonal(int employeeId)
        {
            return repo.GetEmployeePersonal(employeeId);

        }

        public List<EmployeeListDTO> GetAllEmployees()
        {
            return repo.GetAllEmployees();

        }

        public async Task<List<EmployeeMobileListDTO>> GetAllEmployeesByDepartmentId(int departmentId)
        {
            return await repo.GetAllEmployeesByDepartmentId(departmentId);

        }

        public async Task<List<EmployeeMobileListDTO>> GetAllEmployeesByEmployeeNumber(string employeeNumber)
        {
            return await repo.GetAllEmployeesByEmployeeNumber(employeeNumber);

        }

        public async Task<List<EmployeeMobileListDTO>> GetAllEmployeesByEmployeeLastName(string lastName)
        {
            return await repo.GetAllEmployeesByEmployeeLastName(lastName);

        }

        public async Task<List<EmployeeMobileListDTO>> SearchEmployeesMobileListDepartmentIdAndByEmployeeNumber(int departmentId, string employeeNumber)
        {
            return await repo.SearchEmployeesMobileListDepartmentIdAndByEmployeeNumber(departmentId, employeeNumber);

        }

        public async Task<List<EmployeeMobileListDTO>> GetAllEmployeesByEmployeeNumberId(string employeeNumber)
        {
            return await repo.GetAllEmployeesByEmployeeNumber(employeeNumber);

        }

        public async Task<List<EmployeeMobileListDTO>> SearchEmployeesMobileListDepartmentIdAndByLastName(int departmentId, string lastName)
        {
            return await repo.SearchEmployeesMobileListDepartmentIdAndByLastName(departmentId, lastName);

        }


        public async Task<List<EmployeeMobileListDTO>> GetAllMobileListEmployees()
        {
            return await repo.spGetAllMobileListEmployees();

        }

        public async Task<EmployeeDetailDTO> GetEmployeeDetailAsync(string employeeNumber)
        {
            return await repo.GetEmployeeDetailAsync(employeeNumber);
        }

        public async Task<List<EmployeeListDTO>> GetAllEmployeesAsync()
        {
            return await repo.GetAllEmployeesAsync();
        }

        public async Task<List<EmployeeListDTO>> SearchEmployeesByActiveDepartmentNameAsync(string departmentName)
        {
            return await repo.SearchEmployeesByActiveDepartmentNameAsync(departmentName);
        }

        public async Task<List<EmployeeListDTO>> SearchEmployeesByEmployeeNumberAsync(string employeeNumber)
        {
            return await repo.SearchEmployeesByEmployeeNumberAsync(employeeNumber);
        }

        public async Task<List<EmployeeListDTO>> SearchEmployeesByLastNameAsync(string lastName)
        {
            return await repo.SearchEmployeesByLastNameAsync(lastName);
        }

        public async Task<List<EmployeeListDTO>> SearchEmployeesByLastNameByEmpNumber(string employeeNumber, string lastName)
        {
            return await repo.SearchEmployeesByLastNameByEmpNumber(employeeNumber, lastName);
        }

        public async Task<List<EmployeeListDTO>> SearchEmployeesByLastNameByEmpNumberByDepartmentName(string departmentName, string employeeNumber, string lastName)
        {
            return await repo.SearchEmployeesByLastNameByEmpNumberByDepartmentName(departmentName, employeeNumber, lastName);
        }

        public int GetEmployeeCountBySupervisor(int supervisorId)
        {
            return repo.GetEmployeeBySupervisor(supervisorId);
        }

        #endregion

        #region  Private Methods

        private bool ValidateUpdateEmployee(Employee employee)
        {
            employee.Errors.Clear();

            ValidateAge(employee);

            if (IsSinChanged(employee))
            {
                ValidateSIN(employee);
            }

            ValidateEmployeeStatus(employee);

            if (!IsSupervisorChanged(employee))
            {
                ValidateSupervisorDepartment(employee);
            }

            return employee.Errors.Count == 0;
        }



        private bool ValidateEmployee(Employee employee)
        {
            employee.Errors.Clear();

            ValidateAge(employee);
            ValidateSIN(employee);
            ValidateJobStartDate(employee);

            if (employee.SupervisorEmployeeId != 1)
            {

                if (employee.JobAssignmentId != 1)
                {
                    ValidateSupervisorDepartment(employee);
                }

            }
            return employee.Errors.Count == 0;
        }

        private bool IsSinChanged(Employee emp)
        {
            return emp.SIN != repo.GetSinByEmployeeId(emp.Id);
        }

        private void ValidateAge(Employee employee)
        {
            if (employee.DOB.HasValue)
            {
                var age = CalculateAge(employee.DOB.Value);
                if (age < 16)
                {
                    employee.Errors.Add(new ValidationError("Employee must be at least 16 years old.", ErrorType.Business));
                }
                //else if (age >= 65)
                //{
                //    employee.Errors.Add(new ValidationError("Employee must be younger than 65 years old.", ErrorType.Business));
                //}
            }
        }


        private void ValidateSIN(Employee emp)
        {
            bool isSinUnique = repo.IsSinUnique(emp.SIN);
            if (!isSinUnique)
            {
                emp.Errors.Add(new ValidationError("Social Insurance Number (SIN) already exists.", ErrorType.Business));
                return;
            }

        }

        private void ValidateSupervisor(Employee emp)
        {

            if (emp.SupervisorEmployeeId == null)
            {
                return;
            }

            bool isSupervisorValid = repo.IsSupervisorValid(emp.SupervisorEmployeeId.Value);
            if (!isSupervisorValid)
            {
                emp.Errors.Add(new ValidationError("The selected supervisor is not allowed for this department. Please select a valid supervisor.", ErrorType.Business));
                return;
            }
        }


        private void ValidateSupervisorDepartment(Employee emp)
        {
            if (emp.SupervisorEmployeeId == null)
            {
                return;
            }
            int depId = repo.SupervisorDepartment(emp.SupervisorEmployeeId.Value);

            if (depId != emp.DepartmentId)
            {
                emp.Errors.Add(new ValidationError("The selected supervisor is not allowed for this department. Please select a valid supervisor or department.", ErrorType.Business));
                return;
            }
            else
            {
                bool isSupervisorValid = repo.IsSupervisorValid(emp.SupervisorEmployeeId.Value);
                if (!isSupervisorValid)
                {
                    emp.Errors.Add(new ValidationError("A maximum of 10 employees and 1 supervisor can be assigned per department. To add more employees, please assign additional supervisors.", ErrorType.Business));
                    return;
                }

            }

        }

        private bool IsSupervisorChanged(Employee emp)
        {

            int supervisorId = repo.IsSupervisorChanged(emp);

            return emp.SupervisorEmployeeId == supervisorId;
        
          
        }

        private void ValidateJobStartDate(Employee emp)
        {
            if (emp.JobStartDate.HasValue && emp.SeniorityDate > emp.JobStartDate)
            {
                emp.Errors.Add(new ValidationError("Job start date must be later than seniority date.", ErrorType.Business));
            }
        }


        private bool ValidateEmployeeStatus(Employee emp)
        {
            bool isValid = true;

            if (emp.StatusId == 2)
            {
                int employeeAge = CalculateAge(emp.DOB.Value);

                if (employeeAge < 65)
                {
                    emp.Errors.Add(new ValidationError("Employee does not reach retirement age.", ErrorType.Business));
                    isValid = false;
                }
            }
            return isValid;
        }

        private int CalculateAge(DateTime dob)
        {
            DateTime today = DateTime.Today;
            int age = today.Year - dob.Year;

            if (dob.Date > today.AddYears(-age))
            {
                age--;
            }

            return age;
        }




        #endregion


    }
}
