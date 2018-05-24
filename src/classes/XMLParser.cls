public class XMLParser {
 
    // Pass in the URL for the request
    // For the purposes of this sample,assume that the URL
    // returns the XML shown above in the response body
    public static void m1(){
    
        /*String myresponse = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?> '+'<address>'+'<name>'+Kirk Stevens+'</name>'+'<street1>'+808 State St'</street1>'+''<street2>'+Apt. 2+'</street2>'+'
                       '<city>+'+Palookaville+'</city>'+'
                          '<state>'+PA+'</state>'+'
                             '<country>'+USA+'</country>'+
                                   '</address>';*/
        
        //String myresponse = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?> <address><name><![CDATA[<b>Johnson<b>]]></name><street1>808 State St</street1><street2>Apt. 2</street2><city>Palookaville</city><state>PA</state><country>USA</country></address>';
        String myresponse = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?> <address><name><![CDATA[Johnson]]></name><street1>808 State St</street1><street2>Apt. 2</street2><city>Palookaville</city><state>PA</state><country>USA</country></address>';
        System.debug('XML String ::'+myResponse);
        
        // Removing CDATA Tags and replacing the nodes (name node in this case) with actual content
        myresponse = myresponse.replaceAll( '<!\\[CDATA\\[', 'XML_CDATA_START' ).replaceAll( ']]>', 'XML_CDATA_END' );
        Map<String, String> replacementMap = new Map<String, String>();
        Pattern myPattern = Pattern.compile( '(XML_CDATA_START)(.*?)(XML_CDATA_END)' );	
        Matcher myMatcher = myPattern.matcher( myresponse );
        while ( myMatcher.find() ) {
            replacementMap.put( myMatcher.group(), myMatcher.group(2).escapeXML() );	
        }
        
        for ( String key : replacementMap.keySet() ) {	    
            myresponse = myresponse.replace( key, replacementMap.get( key ) );	
        }
        
       System.debug('XML String after formatting ::'+myresponse);
        
        //Retrieve the root element for this document.
        Dom.Document document = new Dom.Document();
        document.load(myresponse);
        Dom.XMLNode address = document.getRootElement();
        system.debug('address ::'+ address);
        

        for(Dom.XMLNode elements : address.getChildElements()) {
            if('name' == elements.getName()) {
                System.debug('name ::'+elements.getText());
            }
            if('street1' == elements.getName()) {
               System.debug('street1 ::'+elements.getText());
            }
            if('street2' == elements.getName()) {
                System.debug('street2 ::'+elements.getText());
            }
            if('city' == elements.getName()) {
               System.debug('city ::'+elements.getText());
            }
            if('state' == elements.getName()) {
                System.debug('state ::'+elements.getText());
            }
            if('country' == elements.getName()) {
                System.debug('country ::'+elements.getText());
            }
        }
        
        /*String name = address.getChildElement('name', null).getText();
        String state = address.getChildElement('state', null).getText();
        // print out specific elements
        System.debug('Name: ' + name);
        System.debug('State: ' + state);
        
        // Alternatively, loop through the child elements.
        // This prints out all the elements of the address
        for(Dom.XMLNode child : address.getChildElements()) {
           System.debug(child.getText());
        }*/
    }
}