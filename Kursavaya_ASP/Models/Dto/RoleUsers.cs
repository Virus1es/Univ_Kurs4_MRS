namespace Kursavaya_ASP.Models.Dto;

// запись для определения роли пользователя 
public record RoleUsers(string DbRole, string MemberName, byte[] MemberSid);
