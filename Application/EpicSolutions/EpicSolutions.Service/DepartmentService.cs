using EpicSolutions.Model;
using EpicSolutions.Repo;
using EpicSolutions.Types;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace EpicSolutions.Service
{
    public class DepartmentService
    {

        #region Private Fields

        private readonly DepartmentRepo repo = new();

        #endregion


        #region Public Methods

        public Department AddDepartment(Department d)
        {

            if (ValidateDepartment(d))
                return repo.AddDepartment(d);

            return d;

        }

        public bool DeleteDepartment(Department d)
        {

            return repo.DeleteDepartment(d.Id);

        }



        public Department UpdateDepartment(Department d)
        {

            if (ValidateUpdateDepartment(d))
                return repo.UpdateDepartment(d);

            return d;

        }


        public async Task<List<DepartmentDTO>> GetAllActiveDepartmentsAsync()
        {
            return await repo.GetAllActiveDepartmentsAsync();
        }

        public List<Department> GetAllDepartments()
        {
            return repo.GetAllDepartments();
        }


        public Department GetDepartmentByEmployeeId(int employeeId)
        {
            return repo.GetDepartmentByEmployeeId(employeeId);
        }

        public Department GetDepartmentById(int departmentId)
        {
            return repo.GetDepartmentById(departmentId);
        }

        public int GetDepartmentByPositionId(int positionId)
        {
            return repo.GetDepartmentByPositionId(positionId);
        }


        #endregion


        #region Private Methods  

        //private bool ValidateDepartmentForDelete(Department d)
        //{

        //    d.Errors.Clear();

        //    bool isDepartmentValidForDelete = repo.IsDepartmentValidForDelete(d);

        //    if (!isDepartmentValidForDelete)
        //    {
        //        d.Errors.Add(new ValidationError("Department cannot be deleted as it is not valid for deletion.", ErrorType.Business));
        //        return false; 
        //    }

        //    return d.Errors.Count == 0;
        //}


        private bool ValidateDepartment(Department d)
        {

            d.Errors.Clear();

            ValidateInvocationDate(d);
            ValidateDepartmentName(d);

            return d.Errors.Count == 0;
        }

        private bool ValidateUpdateDepartment(Department d)
        {

            d.Errors.Clear();

            if (IsDepartmentNameChanged(d))
            {
                ValidateDepartmentName(d);
            }

            if (IsDepartmentInvocationDateChanged(d))
            {
                ValidateInvocationDate(d);
            }


            return d.Errors.Count == 0;
        }

        private void ValidateInvocationDate(Department d)
        {

            if (d.InvocationDate < DateTime.Today)
            {
                d.Errors.Add(new("Department invocation date should be current or future date.", ErrorType.Business));
                return;
            }

        }

        private void ValidateDepartmentName(Department d)
        {

            bool isDepartmantNameIsUnique = repo.IsDepartmantNameIsUnique(d.Name);

            if (!isDepartmantNameIsUnique)
            {
                d.Errors.Add(new ValidationError("Department name already exists.", ErrorType.Business));
                return;
            }

        }

        private bool IsDepartmentNameChanged(Department d)
        {
            return d.Name != GetDepartmentNameById(d.Id);

        }

        private string GetDepartmentNameById(int departmentId)
        {
            return repo.GetDepartmentNameById(departmentId);

        }

        private bool IsDepartmentInvocationDateChanged(Department d)
        {
            return d.InvocationDate != GetDepartmentInvocationDateById(d.Id);

        }

        private DateTime? GetDepartmentInvocationDateById(int departmentId)
        {
            return repo.GetDepartmentInvocationDateById(departmentId);
        }


        #endregion

    }
}
