public with sharing class DateHelpers {
  @AuraEnabled(Cacheable=true)
  public List<String> getDefaultDateRange() {
    //BusinessDateHours()
    DateTime todayDate = DateTime.now();
    DateTime startDate = todayDate.addDays(1);
    DateTime endDate = todayDate.addDays(15);

    String formattedStartDate = startDate.format('yyyy-MM-dd\'T\'HH:mm:ss');
    String formattedEndDate = endDate.format('yyyy-MM-dd\'T\'HH:mm:ss');

    String[] defaultRateRange = new String[2];
    defaultRateRange.add(formattedStartDate);
    defaultRateRange.add(formattedEndDate);
    return defaultRateRange;
  }
  @AuraEnabled(Cacheable=true)
  public static Date getTranslatedDate(String input) {
    
    String[] arrDate = input.split('-');

    Integer year = integer.valueof(arrDate[0]);
    Integer month = integer.valueof(arrDate[1]);
    String[] preDay = arrDate[2].split('T');
    Integer day = integer.valueof(preDay[0]);

    Date output = Date.newInstance(year, month, day);

    return output;
  }
}