using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EpicSolutions.Model
{
    public class ReviewListDTO
    {
        public int ReviewId { get; set; }
        public int EmployeeId { get; set; }
        public int Id { get; set; }
        public int? Year { get; set; }
        public string? QuarterName { get; set; }
        public bool isRead { get; set; }

    }
}


