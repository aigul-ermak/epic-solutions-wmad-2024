using EpicSolutions.Model;
using EpicSolutions.Service;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace EpicSolutions.API.Controllers
{
    [Route("api/employee")]
    [ApiController]
    public class EmployeeAPIController : ControllerBase
    {
        #region Private Fields
        private readonly EmployeeService service = new();


        #endregion


        #region Public Methods

        [HttpGet]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<List<EmployeeListDTO>>> SearchEmployees(string departmentName = null, string employeeNumber = null, string lastName = null)      
        {
            try
            {

                if (string.IsNullOrWhiteSpace(employeeNumber) && string.IsNullOrWhiteSpace(lastName))
                {
                    //List<EmployeeListDTO> allEmployees = await service.GetAllEmployeesAsync();
                    List<EmployeeListDTO> allEmployees = new();
                    return allEmployees;
                }

                List<EmployeeListDTO> searchResults = null;

                if (!string.IsNullOrWhiteSpace(employeeNumber) && !string.IsNullOrWhiteSpace(lastName) && !string.IsNullOrWhiteSpace(departmentName))
                {
                    searchResults = await service.SearchEmployeesByLastNameByEmpNumberByDepartmentName(employeeNumber, lastName, departmentName);
                }
                else if (!string.IsNullOrWhiteSpace(departmentName))
                {
                    searchResults = await service.SearchEmployeesByActiveDepartmentNameAsync(departmentName);
                }
                else
                if (!string.IsNullOrWhiteSpace(employeeNumber))
                {                   
                    searchResults = await service.SearchEmployeesByEmployeeNumberAsync(employeeNumber);
                }
                else if (!string.IsNullOrWhiteSpace(lastName))
                {                    
                    searchResults = await service.SearchEmployeesByLastNameAsync(lastName);
                } 

                if (searchResults == null || searchResults.Count == 0)
                {
                    return new List<EmployeeListDTO>();
                }

                return searchResults;

            }
            catch (Exception)
            {
                return Problem(title: "An internal error has occurred. Please contact the system administrator");

            }
        }

        [HttpGet("browse")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<List<EmployeeMobileListDTO>>> BrowseEmployees(int departmentId = 0, string? employeeNumber = null, string? lastName = null)
     {
            try
            {
                List<EmployeeMobileListDTO>? searchResults = null;

                if (departmentId == 0 && string.IsNullOrWhiteSpace(employeeNumber) && string.IsNullOrWhiteSpace(lastName))
                {
                    List<EmployeeMobileListDTO> allEmployees = await service.GetAllMobileListEmployees();
                    return allEmployees;
                }

                else if (departmentId != 0 && string.IsNullOrWhiteSpace(employeeNumber) && string.IsNullOrWhiteSpace(lastName))
                {
                    searchResults = await service.GetAllEmployeesByDepartmentId(departmentId);
                }
                else if (departmentId == 0 && !string.IsNullOrWhiteSpace(employeeNumber) && string.IsNullOrWhiteSpace(lastName))
                {
                    searchResults = await service.GetAllEmployeesByEmployeeNumberId(employeeNumber);
                }
                else if (departmentId == 0 && string.IsNullOrWhiteSpace(employeeNumber) && !string.IsNullOrWhiteSpace(lastName))
                {
                    searchResults = await service.GetAllEmployeesByEmployeeLastName(lastName);
                }
                //else if (departmentId != 0 && !string.IsNullOrWhiteSpace(employeeNumber) && string.IsNullOrWhiteSpace(lastName))
                //{
                //    searchResults = await service.SearchEmployeesMobileListDepartmentIdAndByEmployeeNumber(departmentId, employeeNumber);
                //}
                else if (departmentId != 0 && string.IsNullOrWhiteSpace(employeeNumber) && !string.IsNullOrWhiteSpace(lastName))
                {
                    searchResults = await service.SearchEmployeesMobileListDepartmentIdAndByLastName(departmentId, lastName);
                }                

                if (searchResults == null || searchResults.Count == 0)
                {
                    return NotFound();
                }

                return searchResults;          

            }
            catch (Exception)
            {
                return Problem(title: "An internal error has occurred. Please contact the system administrator");

            }
        }



        [HttpGet("detail")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<EmployeeDetailDTO>> RetrieveEmployeeDetail(string employeeNumber)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(employeeNumber))
                {
                    return BadRequest("Employee number must be provided.");
                }

                EmployeeDetailDTO employee = await service.GetEmployeeDetailAsync(employeeNumber);

                if (employee == null)
                {
                    return NotFound($"Employee with number {employeeNumber} not found.");
                }

                return Ok(employee); 
            }
            catch (Exception ex)
            {
                
                return Problem(title: "An internal error has occurred. Please contact the system administrator");
            }
        }


        #endregion

    }
}

