using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EpicSolutions.Model
{
    public record EmployeeDetailDTO(string firstName, string middleInitial, string lastName, string homeMailingAddress, string workPhone, string cellPhone, string email);
}
