public class contactListViewHelper {
    
    @AuraEnabled(cacheable=True)
    public static List<Contact> getContacts() {
        try {
            return [SELECT Id, firstName, lastName, accountId, account.name, mailingStreet, 
                    mailingCity, mailingState, mailingPostalCode, mailingCountry, email 
                    FROM Contact
                    LIMIT 1000];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=True)
    public static List<Contact> searchContact(String searchString) {
        try {
            List<List<SObject>> contacts = [FIND :searchString IN ALL FIELDS RETURNING Contact(FirstName, LastName, Email,
                                            MailingStreet, MailingCity, MailingState, MailingCountry, MailingPostalCode, Account.Name)];
            
            return (List<Contact>) contacts[0];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void deleteContacts(List<Id> contactIds) {
        try {
            if (contactIds.size() > 0) {
                delete [SELECT Id FROM Contact WHERE Id IN: contactIds];
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
