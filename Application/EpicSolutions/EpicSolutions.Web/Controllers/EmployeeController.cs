using EpicSolutions.Model;
using EpicSolutions.Service;
using EpicSolutions.Web.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.Data;
using System.Diagnostics;

namespace EpicSolutions.Web.Controllers
{
    public class EmployeeController : Controller
    {
        private readonly EmployeeService empService = new();
        private readonly ListService listService = new();
        private readonly DepartmentService depService = new();
        private readonly LoginService loginService = new();

       
        // GET: EmployeeController
        public async Task<ActionResult> Index(string? employeeNumber, string? lastName, int? page)
        {
            const int pageSize = 5;
            int pageNumber = page ?? 1;

            try
            {
                //var userRole = HttpContext.Session.GetString("Role");
                var userId = Convert.ToInt32(HttpContext.Session.GetString("UserId"));

                List<EmployeeListDTO> employees = new List<EmployeeListDTO>();

                if (String.IsNullOrEmpty(employeeNumber) && String.IsNullOrEmpty(lastName))
                {
                    employees = await empService.GetAllEmployeesAsync();
                }
                else
                {
                    employees = await empService.SearchEmployeesByLastNameByEmpNumber(employeeNumber, lastName);
                }

                if (!employees.Any())
                {
                    TempData["SearchEmpty"] = "No employees match your search criteria.";
                }

                var pageEmployees = employees.Skip((pageNumber - 1) * pageSize).Take(pageSize).ToList();
                ViewBag.TotalPages = (int)Math.Ceiling(employees.Count / (double)pageSize);
                ViewBag.CurrentPage = pageNumber;
                ViewBag.UserId = userId;


                return View(pageEmployees);
            }
            catch (Exception ex)
            {

                TempData["Error"] = "An error occurred while processing your request.";
                return RedirectToAction("Error");
            }
        }


        public async Task<ActionResult> EmployeeArea(int employeeId)
        {
            try
            {

                List<DepartmentDTO> departments = await depService.GetAllActiveDepartmentsAsync();

                List<PositionListDTO> positions = GetJobAssignments();

                List<Status> statuses = listService.GetEmployeeStatusList();

                List<SupervisorEmployee> supervisors = listService.GetSupervisorList();

                EmployeeAreaDTO emp = await empService.GetEmployeeInfo(employeeId);
                bool isRetired = emp.StatusId == 2;

                var departmentSelectListItems = departments.Select(d => new SelectListItem
                {
                    Value = d.Id.ToString(),
                    Text = d.Name
                }).ToList();

                var positionElectedItems = positions.Select(p => new SelectListItem
                {
                    Value = p.Id.ToString(),
                    Text = p.Name
                }).ToList();

                var statusElectedItems = statuses.Select(s => new SelectListItem
                {
                    Value = s.StatusId.ToString(),
                    Text = s.StatusName
                }).ToList();

                var supervisorElectedItems = supervisors.Select(s => new SelectListItem
                {
                    Value = s.Id.ToString(),
                    Text = $"{s.Name} - {s.Department}"
                }).ToList();


                EmployeeAreaVM employeeArea = new EmployeeAreaVM
                {
                    Employee = emp,
                    Departments = departmentSelectListItems,
                    JobAssignments = positionElectedItems,
                    Statuses = statusElectedItems,
                    Supervisors = supervisorElectedItems,
                    isRetired = isRetired
                };


                return View(employeeArea);
            }
            catch (Exception ex)
            {

                return RedirectToAction("Dashboard", "Employee", new { message = "An error occurred while retrieving employee information." });
            }
        }

        [HttpPost]
        public async Task<ActionResult> EmployeeArea(EmployeeAreaVM empVM)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    await PopulateEmployeeAreaVMLists(empVM);
                    return View(empVM);
                }

                Employee employee = new Employee
                {
                    Id = empVM.Employee.Id,
                    FirstName = empVM.Employee.FirstName,
                    MiddleInitial = empVM.Employee.MiddleInitial,
                    LastName = empVM.Employee.LastName,
                    StreetAddress = empVM.Employee.StreetAddress,
                    City = empVM.Employee.City,
                    PostalCode = empVM.Employee.PostalCode,
                    DOB = empVM.Employee.DOB,
                    SIN = empVM.Employee.SIN,
                    SeniorityDate = empVM.Employee.SeniorityDate,
                    JobStartDate = empVM.Employee.JobStartDate,
                    RetirementDate = empVM.Employee.RetirementDate,
                    TerminationDate = empVM.Employee.TerminationDate,
                    SupervisorEmployeeId = empVM.Employee.SupervisorEmployeeId,
                    WorkPhone = empVM.Employee.WorkPhone,
                    CellPhone = empVM.Employee.CellPhone,
                    Email = empVM.Employee.Email,
                    DepartmentId = empVM.Employee.DepartmentId,
                    JobAssignmentId = empVM.Employee.JobAssignmentId,
                    StatusId = empVM.Employee.StatusId,
                    RecordVersion = empVM.Employee.RecordVersion
                };

                UpdateEmployeeFields(employee);



                try
                {
                    var result = await empService.UpdateEmployeeInfoAsync(employee);

                    if (result.Errors.Count != 0)
                    {
                        string errorMessage = "";
                        foreach (var error in result.Errors)
                        {
                            errorMessage += error.Description + " ";
                        }
                        ViewBag.ErrorMessage = errorMessage;

                        await PopulateEmployeeAreaVMLists(empVM);
                        return View(empVM);

                    }

                    TempData["SuccessMessage"] = "Employee Information updated successfully.";
                    return RedirectToAction("EmployeeArea", "Employee", new { employeeId = empVM.Employee.Id });

                }
                catch (Exception ex)
                {

                    ViewBag.ErrorMessage = ex.Message;
                    await PopulateEmployeeAreaVMLists(empVM);
                    return View(empVM);
                }
            }
            catch (Exception ex)
            {
                ViewBag.ErrorMessage = ex.Message;
                return View(empVM);
            }

        }

        // GET: EmployeeController/Details/5
        public ActionResult Details(int employeeId)
        {
            EmployeePersonalDTO emp = empService.GetEmployeePersonal(employeeId);
            return View(emp);
        }

        public ActionResult Personal(int employeeId)
        {

            EmployeePersonalDTO emp = empService.GetEmployeePersonal(employeeId);

            return View(emp);
        }

        [HttpPost]
        public ActionResult Personal(EmployeePersonalDTO p)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return View(p);
                }

                Employee existingEmp = empService.GetEmployee(p.Id);

                if (existingEmp == null)
                {
                    return NotFound();
                }

                existingEmp.StreetAddress = p.StreetAddress;
                existingEmp.City = p.City;
                existingEmp.PostalCode = p.PostalCode;
                existingEmp.RecordVersion = p.RecordVersion;

                bool success = empService.UpdateEmployeePersonal(existingEmp);

                if (!success)
                {
                    ViewBag.ErrorMessage = "An error occurred while updating the Personal Information.";
                    return View(p);
                }
                return RedirectToAction("Dashboard", "Employee", new { successMessage = "Personal Information updated successfully." });
            }
            catch (Exception ex)
            {
                ViewBag.ErrorMessage = ex.Message;
                return View(p);
            }

        }

        public ActionResult PersonalPassword(int employeeId)
        {

            EmployeePasswordDTO emp = empService.GetEmployeePersonalPasswordDTO(employeeId);

            return View(emp);
        }

        [HttpPost]
        public ActionResult PersonalPassword(EmployeePasswordDTO emp)
        {
            try
            {
                Employee existingEmp = empService.GetEmployee(emp.Id);

                if (existingEmp == null)
                {
                    return NotFound();
                }

                if (!string.IsNullOrEmpty(emp.HashedPassword) && ModelState.IsValid)
                {
                    existingEmp.HashedPassword = emp.HashedPassword;
                    existingEmp.RecordVersion = emp.RecordVersion;

                    bool success = empService.UpdateEmployeePersonalPassword(existingEmp);

                    if (!success)
                    {
                        ViewBag.ErrorMessage = "An error occurred while updating the Password.";
                        return View(emp);
                    }

                    return RedirectToAction("Dashboard", "Employee", new { successMessage = "Password updated successfully." });
                }

                ViewBag.ErrorMessage = "Invalid password.";
                return View(emp);
            }
            catch (Exception ex)
            {
                ViewBag.ErrorMessage = ex.Message;
                return View(emp);
            }
        }


        public ActionResult Dashboard(string successMessage = null)
        {
            var userRole = HttpContext.Session.GetString("Role");
            var userId = Convert.ToInt32(HttpContext.Session.GetString("UserId"));

            ViewBag.SuccessMessage = successMessage;

            if (userRole == null)
            {
                return RedirectToAction("Index", "Home");
            }

            DashboardVM viewModel = new DashboardVM();

            viewModel.Employee = empService.GetEmployeeDTO(userId);
            viewModel.Department = depService.GetDepartmentByEmployeeId(userId);

            ViewBag.UserRole = userRole;

            return View(viewModel);
        }

        // GET: EmployeeController/Create
        public async Task<ActionResult> Create()
        {
            try
            {
                var userRole = HttpContext.Session.GetString("Role");

                if (userRole == null)
                {
                    return RedirectToAction("Index", "Home");
                }

                List<Status> statuses = listService.GetEmployeeStatusList();

                List<DepartmentDTO> departments = await depService.GetAllActiveDepartmentsAsync();

                List<PositionListDTO> positions = GetJobAssignments();

                List<RoleDTO> roles = listService.GetRolesList();

                List<SupervisorEmployee> supervisors = listService.GetSupervisorList();


                var departmentSelectListItems = departments.Select(d => new SelectListItem
                {
                    Value = d.Id.ToString(),
                    Text = d.Name
                }).ToList();

                var positionElectedItems = positions.Select(p => new SelectListItem
                {
                    Value = p.Id.ToString(),
                    Text = p.Name
                }).ToList();

                var rolesElectedItems = roles.Select(r => new SelectListItem
                {
                    Value = r.Id.ToString(),
                    Text = r.Name
                }).ToList();

                var supervisorElectedItems = supervisors.Select(s => new SelectListItem
                {
                    Value = s.Id.ToString(),
                    Text = $"{s.Name} - {s.Department}"
                }).ToList();

                var statusElectedItems = statuses
                 .Where(s => s.StatusId != 2)
                 .Select(s => new SelectListItem
                 {
                     Value = s.StatusId.ToString(),
                     Text = s.StatusName,
                     Selected = (s.StatusName == "Active")
                 }).ToList();



                EmployeeAddViewVM emp = new EmployeeAddViewVM
                {
                    Employee = new Employee(),
                    Departments = departmentSelectListItems,
                    JobAssignments = positionElectedItems,
                    Roles = rolesElectedItems,
                    SupervisorsEmployees = supervisorElectedItems,
                    Statuses = statusElectedItems
                };

                return View(emp);
            }
            catch (Exception ex)

            {
                return ShowError(ex);
            }

        }


        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Create(EmployeeAddViewVM emp)
        {

            try
            {
                if (!ModelState.IsValid)
                {
                    await PopulateEmployeeAddViewVM(emp);
                    return View(emp);
                }

                UpdateAddEmployeeFields(emp.Employee);

                var result = empService.AddEmployee(emp.Employee);

                if (result.Errors.Count != 0)
                {
                    string errorMessage = "";
                    foreach (var error in result.Errors)
                    {
                        errorMessage += error.Description + " ";
                    }
                    ViewBag.ErrorMessage = errorMessage;

                    await PopulateEmployeeAddViewVM(emp);
                    return View(emp);
                }

                return RedirectToAction("Dashboard", "Employee", new { successMessage = "Employee created successfully." });

            }
            catch (Exception ex)

            {
                return ShowError(ex);
            }
        }

        public List<PositionListDTO> GetJobAssignments()
        {
            return listService.GetJobAssignmentList();
        }


        //public JsonResult getRoles(int id)
        //{
        //    var roles = listService.getSupervisorsByPositionId(id);
        //    return new JsonResult(roles);
        //}

        //public JsonResult getDepartments(int id)
        //{
        //    var departments = listService.GetDepartmentListById(id);
        //    return new JsonResult(departments);
        //}


        //public JsonResult getSupervisorsByPositionId(int positionId)
        //{
        //    var supervisors = listService.getSupervisorsByPositionId(positionId);
        //    return new JsonResult(supervisors);
        //}


        // GET: EmployeeController/Delete/5
        public ActionResult Delete(int id)
        {
            return View();
        }

        // POST: EmployeeController/Delete/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Delete(int id, IFormCollection collection)
        {
            try
            {
                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View();
            }
        }


        #region Private Methods     

        private void UpdateEmployeeFields(Employee employee)
        {
            var existingEmployee = empService.GetEmployee(employee.Id);

            if (existingEmployee != null && employee.JobAssignmentId != existingEmployee.JobAssignmentId)
            {
                employee.JobStartDate = DateTime.UtcNow;                
            } else if (employee.StatusId == 1)
            {
                employee.SeniorityDate = DateTime.UtcNow;
                employee.JobStartDate = null;
            }

        }

        private void UpdateAddEmployeeFields(Employee employee)
        {

            if (employee.StatusId == 3)
            {
                employee.TerminationDate = employee.SeniorityDate;

            }
        }

        private async Task PopulateEmployeeAddViewVM(EmployeeAddViewVM empVM)
        {
            var departments = await depService.GetAllActiveDepartmentsAsync();
            empVM.Departments = (departments ?? new List<DepartmentDTO>())
                .Select(d => new SelectListItem
                {
                    Value = d.Id.ToString(),
                    Text = d.Name
                }).ToList();

            var jobAssignments = GetJobAssignments();
            empVM.JobAssignments = (jobAssignments ?? new List<PositionListDTO>())
                .Select(p => new SelectListItem
                {
                    Value = p.Id.ToString(),
                    Text = p.Name
                }).ToList();

            var roles = listService.GetRolesList();
            empVM.Roles = (roles ?? new List<RoleDTO>())
                .Select(s => new SelectListItem
                {
                    Value = s.Id.ToString(),
                    Text = s.Name
                }).ToList();

            var supervisors = listService.GetSupervisorList();
            empVM.SupervisorsEmployees = (supervisors ?? new List<SupervisorEmployee>())
                .Select(s => new SelectListItem
                {
                    Value = s.Id.ToString(),
                    Text = $"{s.Name} - {s.Department}"
                }).ToList();          

            var statuses = listService.GetEmployeeStatusList();
            empVM.Statuses = (statuses ?? new List<Status>())
                .Where(s => s.StatusId != 2)
                .Select(s => new SelectListItem
                {
                    Value = s.StatusId.ToString(),
                    Text = s.StatusName,
                }).ToList();
        }


        private async Task PopulateEmployeeAreaVMLists(EmployeeAreaVM empVM)
        {
            empVM.Departments = (await depService.GetAllActiveDepartmentsAsync()).Select(d => new SelectListItem
            {
                Value = d.Id.ToString(),
                Text = d.Name
            }).ToList();

            empVM.JobAssignments = GetJobAssignments().Select(p => new SelectListItem
            {
                Value = p.Id.ToString(),
                Text = p.Name
            }).ToList();

            empVM.Statuses = listService.GetEmployeeStatusList().Select(s => new SelectListItem
            {
                Value = s.StatusId.ToString(),
                Text = s.StatusName
            }).ToList();

            empVM.Supervisors = listService.GetSupervisorList().Select(s => new SelectListItem
            {
                Value = s.Id.ToString(),
                Text = $"{s.Name} - {s.Department}"
            }).ToList();
        }

        private bool IsEmployeeChanged(Employee original, Employee modified)
        {

            return !(original.FirstName == modified.FirstName &&
                     original.MiddleInitial == modified.MiddleInitial &&
                     original.LastName == modified.LastName &&
                     original.StreetAddress == modified.StreetAddress &&
                     original.City == modified.City &&
                     original.PostalCode == modified.PostalCode &&
                     original.DOB == modified.DOB &&
                     original.SIN == modified.SIN &&
                     original.SeniorityDate == modified.SeniorityDate &&
                     original.JobStartDate == modified.JobStartDate &&
                     original.RetirementDate == modified.RetirementDate &&
                     original.TerminationDate == modified.TerminationDate &&
                     original.SupervisorEmployeeId == modified.SupervisorEmployeeId &&
                     original.WorkPhone == modified.WorkPhone &&
                     original.CellPhone == modified.CellPhone &&
                     original.Email == modified.Email &&
                     original.DepartmentId == modified.DepartmentId &&
                     original.JobAssignmentId == modified.JobAssignmentId &&
                     original.StatusId == modified.StatusId);
        }

        private ActionResult ShowError(Exception ex)
        {
            return View("Error", new ErrorViewModel
            {
                RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier,
                Exception = ex
            });
        }

        #endregion
    }
}
