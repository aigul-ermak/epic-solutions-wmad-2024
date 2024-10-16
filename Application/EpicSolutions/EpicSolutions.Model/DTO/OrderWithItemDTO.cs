using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EpicSolutions.Model
{
    public class OrderWithItemDTO : BaseEntity
    {
        public OrderDTO? OrderDetails { get; set; }

        public List<ItemDTO>? Items { get; set; }

    }
}
