using EpicSolutions.Model;
using EpicSolutions.Service;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace EpicSolutions.API.Controllers
{
    [Route("api/department")]
    [ApiController]
    public class DepartmentAPIController : ControllerBase
    {

        private readonly DepartmentService service = new();

        [HttpGet]
        public async Task<ActionResult<List<DepartmentDTO>>> GetAllDepartments()
        {
            try
            {
                List<DepartmentDTO> departments = await service.GetAllActiveDepartmentsAsync();

                if (departments == null || departments.Count == 0)
                {
                    return new List<DepartmentDTO>();
                }

                return departments;

            }
            catch (Exception)
            {
                return Problem(title: "An internal error has occurred. Please contact the system administrator");

            }
        }

    }
}
