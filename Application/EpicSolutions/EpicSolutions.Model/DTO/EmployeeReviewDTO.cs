using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EpicSolutions.Model
{
    public class EmployeeReviewDTO
    {
        public int Year { get; set; }

        public int Quarter { get; set; }

        public string QuarterName { get; set; }

        public int EmployeeId { get; set; }

        public string FirstName { get; set; }

        public string LastName { get; set; }
       
    }
}
