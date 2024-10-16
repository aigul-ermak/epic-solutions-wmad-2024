using EpicSolutions.API.Interfaces;
using EpicSolutions.Model;
using EpicSolutions.Service;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace EpicSolutions.API.Controllers
{



    [Route("api/login")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly LoginService service = new LoginService();
        private readonly ITokenService _tokenService;

        public AuthController(ITokenService tokenService)
        {
            _tokenService = tokenService;
        }

        [HttpPost]
        public async Task<ActionResult<LoginOutputDTO>> Login(LoginDTO credentials)
        {
            EmployeeUserDTO? emp = await service.Login(credentials);

            if (emp == null)
            {
                return Unauthorized("Invalid login");
            }

            return new LoginOutputDTO()
            {
                EmployeeNumber = emp.EmployeeNumber,
                Token = _tokenService.CreateToken(emp),
                ExpiresIn = 7 * 24 * 60 * 60
            };
        }
    }
}
