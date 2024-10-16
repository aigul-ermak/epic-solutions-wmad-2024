using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EpicSolutions.Model
{
    public record EmployeeListDTO(int employeeId, string employeeNumber, string lastName, string firstName, string workPhone, string officeLocation, string position);

}
 