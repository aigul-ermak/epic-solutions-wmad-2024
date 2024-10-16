using EpicSolutions.Model;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.AspNetCore.Mvc;

namespace EpicSolutions.Web.Models
{
    public class EmployeeAreaVM    
    {        

        public EmployeeAreaDTO? Employee { get; set; }

        public IEnumerable<SelectListItem>? Departments { get; set; }

        public IEnumerable<SelectListItem>? JobAssignments { get; set; }

        public IEnumerable<SelectListItem>? Statuses { get; set; }

        public IEnumerable<SelectListItem>? Supervisors { get; set; }

        public bool isRetired { get; set; }

    }

}
