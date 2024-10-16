using EpicSolutions.Model;
using Microsoft.AspNetCore.Mvc.Rendering;

namespace EpicSolutions.Web.Models
{
    public class EmployeeAddViewVM
    {
        public Employee? Employee { get; set; }   

        public IEnumerable<SelectListItem>? JobAssignments { get; set; }  

        public IEnumerable<SelectListItem>? Departments { get; set; }

        public IEnumerable<SelectListItem>? SupervisorsEmployees { get; set; }

        public IEnumerable<SelectListItem>? Roles { get; set; }

        public IEnumerable<SelectListItem>? Statuses { get; set; }


    }
}
