using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EpicSolutions.Model
{
    public class OrderItemDTO : BaseEntity
    {
        public string? OrderNumber { get; set; }
        public Order Order { get; set; } = new();
        public Item Item { get; set; } = new();

    }
}
