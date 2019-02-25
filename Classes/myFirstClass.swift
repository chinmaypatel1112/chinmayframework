//
//  myFirstClass.swift
//  chinmayframework
//
//  Created by Chinmay's Mac on 25/02/19.
//

import Foundation


public class service {
    private init(){}



    public static func validateEmail(enteredEmail:String) -> Bool
    {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }



}
