public class VFPageController {

public String PDFData {get; set;} 
    
    public VFPageController(){
        PDFData = '';
    }
    
    public PageReference downloadPDF(){
        System.PageReference pageRef = new System.PageReference('/apex/VFPDFGenerator');
    
        //ensure pdf downloads and is assigned with defined name
        pageRef.getHeaders().put('content-disposition', 'attachment; filename=TestPDF.pdf');
     
        return pageRef;
    }

}