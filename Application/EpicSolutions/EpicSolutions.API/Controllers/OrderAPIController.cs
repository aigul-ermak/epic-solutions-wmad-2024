using EpicSolutions.Model;
using EpicSolutions.Service;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace EpicSolutions.API.Controllers
{

    //[Authorize]
    [Route("api/order")]
    [ApiController]
    public class OrderAPIController : ControllerBase
    {
        private readonly OrderService service = new();
        private readonly ListService list = new();
        private readonly EmployeeService employee = new();


        [HttpGet]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<List<OrderApiDTO>>> Get(string? departmentId = null)
        {
            try
            {
                
                if (String.IsNullOrEmpty(departmentId))
                {
                    return BadRequest("The department is not specified.");
                }
                
                
                if(!int.TryParse(departmentId, out int id))
                {
                    return BadRequest("The department is incorrect; please enter an integer.");
                }

                List<DepartmentDTO> departments = list.GetDepartmentList();
                departments = departments.Where(d => d.Id == id).ToList();

                if(departments.Count == 0)
                {
                    return NotFound(new List<OrderApiDTO>());
                }

                var orders = await service.GetAllOrdersAsync(id);
                return Ok(orders);
            }
            catch (Exception)
            {
                return Problem(title: "An internal error has occurred. Please contact the system administrator");

            }
        }

        [HttpGet("byUser")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<List<OrderApiDTO>>> GetUserOrders(string? userId = null)
        {
            try
            {

                if (String.IsNullOrEmpty(userId))
                {
                    return BadRequest("The user is not specified.");
                }


                if (!int.TryParse(userId, out int id))
                {
                    return BadRequest("The user ID is incorrect; please enter an integer.");
                }

                Employee emp = employee.GetEmployee(id);
                

                if (emp == null)
                {
                    return NotFound(new List<OrderApiDTO>());
                }

                List<OrderSummaryDTO> orders = await service.GetUserOrdersListAsync(id);
                return Ok(orders);
            }
            catch (Exception)
            {
                return Problem(title: "An internal error has occurred. Please contact the system administrator");

            }
        }

        [HttpGet("bySupervisor")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<List<OrderApiDTO>>> GetSupervisorOrders(string? userId = null)
        {
            try
            {

                if (String.IsNullOrEmpty(userId))
                {
                    return BadRequest("The supervisor is not specified.");
                }


                if (!int.TryParse(userId, out int id))
                {
                    return BadRequest("The supervisor ID is incorrect; please enter an integer.");
                }

                Employee emp = employee.GetEmployee(id);


                if (emp == null)
                {
                    return NotFound(new List<OrderApiDTO>());
                }

                List<OrderSummaryDTO> orders = await service.GetSupervisorOrdersListAsync(id);
                return Ok(orders);
            }
            catch (Exception)
            {
                return Problem(title: "An internal error has occurred. Please contact the system administrator");

            }
        }


        [HttpGet("detail")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<DetailOrderApiDTO>> GetDetail(string? orderId)
        {
            try
            {

                if (String.IsNullOrEmpty(orderId))
                {
                    return BadRequest("The order is not specified.");
                }


                if (!int.TryParse(orderId, out int id))
                {
                    return BadRequest("The order number is incorrect; please enter an integer.");
                }

                OrderWithItemDTO order = service.GetOrderWithItem(id);


                if (order == null)
                {
                    return NotFound("The order is not found.");
                }

                DetailOrderApiDTO ordersDetail = new DetailOrderApiDTO
                {
                    OrderId = order.OrderDetails.OrderId,
                    OrderNumber = order.OrderDetails.PoNumber,
                    StatusName = order.OrderDetails.StatusName,
                    ItemsNumber = order.Items.Where(itm => itm.StatusName != "Deny").Count(),
                    SupervisorName = order.OrderDetails.SupervisorName,
                    Total = order.OrderDetails.Total
                };

                return Ok(ordersDetail);
            }
            catch (Exception)
            {
                return Problem(title: "An internal error has occurred. Please contact the system administrator");

            }
        }
    }
}
