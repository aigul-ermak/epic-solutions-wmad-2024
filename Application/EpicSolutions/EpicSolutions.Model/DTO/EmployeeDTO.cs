﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EpicSolutions.Model
{
    public class EmployeeDTO
    {
        public int Id { get; set; }
        public string? FirstName { get; set; }
        public string? LastName { get; set; }
        public string? Email { get; set; }
        public string? WorkPhone { get; set; }
        public DateTime? DateHired { get; set; }
        public string?  Position { get; set; }
        public string?  Department { get; set; }
        public string? FullName => $"{FirstName} {LastName}";
    }
}
