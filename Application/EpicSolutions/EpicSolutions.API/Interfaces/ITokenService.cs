using EpicSolutions.Model;

namespace EpicSolutions.API.Interfaces
{
    public interface ITokenService
    {
        string CreateToken(EmployeeUserDTO user);      
        
    }
}
