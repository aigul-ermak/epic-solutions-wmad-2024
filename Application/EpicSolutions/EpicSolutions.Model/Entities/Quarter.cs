using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EpicSolutions.Model
{
    public class Quarter
    {
        public int Id { get; set; }

        public string QuarterName { get; set; }

        public int StartMonth { get; set; }

        public int EndMonth { get; set; }

        public int StartDate { get; set; }

        public  int EndDate { get; set; }
    }
}
