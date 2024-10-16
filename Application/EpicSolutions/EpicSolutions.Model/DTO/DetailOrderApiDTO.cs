using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EpicSolutions.Model
{
    public class DetailOrderApiDTO
    {
        public int OrderId { get; set; }
        public string? OrderNumber { get; set; }
        public string? SupervisorName { get; set; }
        public string? StatusName { get; set; }
        public int ItemsNumber { get; set; }
        public decimal Total { get; set; }

    }
}
