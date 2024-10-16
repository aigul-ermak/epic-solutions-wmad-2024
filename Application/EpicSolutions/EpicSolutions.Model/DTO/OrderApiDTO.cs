using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EpicSolutions.Model
{
    public class OrderApiDTO
    {
        public int OrderId { get; set; }
        public string? OrderNumber { get; set; }
        public DateTime CreationDate { get; set; }
        public string? SupervisorName { get; set; }
        public string? StatusName { get; set; }
        public int DepartmentId { get; set; }


    }
}
