public with sharing class ConvertCurrencyToWordsEN { 
    
    static String[] to_19 = new string[]{ 'Zero', 'One',  'Two', 'Three', 'Four',  'Five',  'Six', 'Seven','Eight', 'Nine', 'Ten',  'Eleven', 'Twelve', 'Thirteen',  'Forteen', 'Fifteen', 'Sixteen', 'Seventeen', 'Eighteen', 'Nighteen' }; 
        static String[] tens = new string[]{ 'Twenty', 'Thirty', 'Fourty','Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety'}; 
            
            static String[] zero_to_tens = new string[]{'Zero','Ten','Twenty', 'Thirty', 'Fourty','Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety'}; 
            
            static string[] denom = new string[]{ '', 
                'Thousand',   'Million',     'Billion',    'Trilion',    'Quatrilion', 'quintillion', 's!xtillion',   'septillion',  'octillion',   'nonillion',  'decillion',  'undecillion',   'duodecillion', 'tredecillion',  'quattuordecillion',  's!xdecillion', 'septendecillion', 'octodecillion', 'novemdecillion', 'vigintillion' }; 
                    
                    // convert a value < 100 to English.   
                    public static string convert_nn(integer val) { 
                        if (val < 20) 
                            return to_19[val]; 
                        if (val == 100) 
                            return 'Hundred'; 
                        for (integer v = 0; v < tens.size(); v++) { 
                            String dcap = tens[v]; 
                            integer dval = 20 + 10 * v; 
                            if (dval + 10 > val) { 
                                if (Math.Mod(val,10) != 0) 
                                    return dcap + ' ' + to_19[Math.Mod(val,10)]; 
                                return dcap; 
                            }     
                        } 
                        return 'Should never get here, less than 100 failure'; 
                    } 
    // convert a value < 1000 to english, special cased because it is the level that kicks   
    // off the < 100 special case. The rest are more general. This also allows you to  
    // get strings in the form of "forty-five hundred" if called directly.  
    public static String convert_nnn(integer val) { 
        string word = ''; 
        integer rem = val / 100; 
        integer mod = Math.mod(val,100); 
        if (rem > 0) { 
            word = to_19[rem] + ' Hundred '; 
            if (mod > 0) { 
                word += ' '; 
            } 
        } 
        if (mod > 0) { 
            word += convert_nn(mod); 
        } 
        return word; 
    } 
    
    public static String english_number(long val) { 
        if (val < 100) { 
            return convert_nn(val.intValue()); 
        } 
        if (val < 1000) { 
            return convert_nnn(val.intValue()); 
        } 
        for (integer v = 0; v < denom.size(); v++) { 
            integer didx = v - 1; 
            integer dval = (integer)Math.pow(1000, v); 
            if (dval > val) { 
                integer mod = (integer)Math.pow(1000, didx); 
                integer l = (integer) val / mod; 
                integer r = (integer) val - (l * mod); 
                String ret = convert_nnn(l) + ' ' + denom[didx]; 
                if (r > 0) { 
                    ret += ', ' + english_number(r); 
                } 
                return ret; 
            } 
        } 
        return 'Should never get here, bottomed out in english_number'; 
    } 
    
    public static String cent_in_word(decimal v) { 
        string cent = ''; 
        String s = String.valueOf(v);
		String[] arrayDecimal = s.split('\\.');
        
        if(arrayDecimal.size()>1){
            integer num=integer.valueOf(arrayDecimal[1]);
            if(num==10){
                return cent='Ten';
            }
            
            string strNum=arrayDecimal[1];
            if(strNum.length()==1){
            	return cent =to_19[integer.valueOf(strNum.substring(0,1))];         
            }
            
            if(num<20 && strNum.length()==2){
                return cent =to_19[integer.valueOf(strNum.substring(0,2))];     
            }
            
            if(strNum.length()==2 && strNum.substring(1,2)=='0'){
                return cent=zero_to_tens[integer.valueOf(strNum.substring(0,1))];        
            }
            
            if(strNum.length()==2){
                return cent=zero_to_tens[integer.valueOf(strNum.substring(0,1))] +' '+ to_19[integer.valueOf(strNum.substring(1,2))];        
            }
        	
        }
        
        return cent;
    }
    
}