using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EpicSolutions.Model
{

   //  public record EmployeeUserDTO(int EmployeeId, string? EmployeeNumber, string? Email, string? RoleName, string? Department, string? Supervisor);
   public class EmployeeUserDTO
    {

        public int EmployeeId { get; set; }
        public string? EmployeeNumber { get; set; }
        public string? EmployeeName { get; set; }
        public string? Email { get; set; }
        public string? RoleName { get; set; }
        public string? Department { get; set; }
        public string? Supervisor { get; set; }

    }

}
