﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EpicSolutions.Model
{    
    public class LoginOutputDTO
    {
        public string? EmployeeNumber { get; set; }
        public string? Token { get; set; }
        public int ExpiresIn { get; set; }
    }
}
