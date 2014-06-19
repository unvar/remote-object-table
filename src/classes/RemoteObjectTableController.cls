public class RemoteObjectTableController {    
    public String cName { get; set; }
    public String cFields { get; set; }
    public String cHeaders { get; set; }

    public String[] getHeaderValues() {
      return cHeaders.split(',');
    }

    public String[] getFieldValues() {
      return cFields.split(',');
    }

    public Integer getFieldCount() {
      return cFields.split(',').size();
    }

    public String getUserLocale() {
      return UserInfo.getLocale();
    }

    public String getUserLanguage() {
      return UserInfo.getLanguage();
    }
 }