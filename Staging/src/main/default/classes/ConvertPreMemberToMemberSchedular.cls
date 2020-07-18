public class ConvertPreMemberToMemberSchedular implements Schedulable {
    
    public void execute(SchedulableContext obj)
    {
      ConvertPreMemberToMemberBatchClass obj1 = new ConvertPreMemberToMemberBatchClass();
          Database.executeBatch(obj1, 5);
      
    }
    public static string clearPhoneNumber(string phoneNumber)
    {
      if(phoneNumber != null)
      {
        return phoneNumber.remove(' ').remove('(').remove(')').remove('-');
      }
      return '';
    }
}