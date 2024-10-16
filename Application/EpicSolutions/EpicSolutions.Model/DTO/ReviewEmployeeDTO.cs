using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EpicSolutions.Model.DTO
{
    public record ReviewEmployeeDTO(int Year, string QuarterName, DateTime CompletionDate, string SupervisorFullName, string Comment, string RatingName);
}
