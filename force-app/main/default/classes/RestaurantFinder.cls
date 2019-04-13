public with sharing class RestaurantFinder {
    @AuraEnabled(cacheable=true)
    public static List<Object> getRestaurantList(ID contactId){
       Contact contact = [select name, MailingLatitude, MailingLongitude from Contact where id=:contactId]; 
       HttpRequest req = new HttpRequest();
       String url = 'https://api.yelp.com/v3/businesses/search?latitude='+ contact.MailingLatitude 
                                + '&longitude=' + contact.MailingLongitude 
                                + '&term=Restaurants&radius=10000&limit=5';
       Http http = new Http();
       req.setMethod('GET');
       req.setEndpoint(url);    
       req.setHeader(
           'Authorization', 
           'Bearer lEBaR-Fudy_iiRInSrXyagwNo3clmE7yEdCAmlKM1oW8RvfOHiPHglh5OaIDEyya0f2W-Pjb5OG2Ne8kCA_dPx_lo2MvuE2dA1yBCEJx5xzWBxodwtEuXl1bch6xXHYx');
       HTTPResponse res = http.send(req);
       String response =  res.getBody();
       Map<String,Object> m = (Map<String,Object>) JSON.deserializeUntyped(response);
       return (List<Object>) m.get('businesses');
    }

    @AuraEnabled
    public static void createEvent(String duration, DateTime dt, Id contactId, String rName){
        Event e = new Event();
        e.StartDateTime = dt;
        e.EndDateTime = e.StartDateTime.addHours(Integer.valueOf(duration));
        e.Subject = 'Casual Meeting';
        e.Location = rName;
        e.WhoId = contactId;
        insert e;
    }

    @AuraEnabled(cacheable=true)
    public static List<Event> pastAppointments(Id contactId){
        return [select Subject, Location, StartDateTime from Event where WhoId =: contactId];
    }
}