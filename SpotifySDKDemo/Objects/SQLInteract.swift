//
//  SQLInteract.swift
//  ClassesManager
//
//  Created by Jose Carlos on 2/8/18.
//  Copyright © 2018 PassDatClass. All rights reserved.
//
//
/* Implemented by Jose Carlos & Jordan Mussman */

public typealias ResQuery = [[String: Any]]
public typealias RowQuery = [String:Any]
public typealias StatusMsg = (status: Bool, msg: String)


import Foundation
import Alamofire
import Alamofire_Synchronous

public class SQLInteract{
    //MARK: Propierties
    static var phpFile: URL! = URL(string: "https://jcquiles.com/DRDatabase.php") // e.g. http://jcquiles.com/DRDatabase.php
    static let host = "localhost"
    /* If your database is on the same server as the php file,
     *  use 'localhost' , otherwise use the ip address of
     *  your database and configure remote access.
     */
    static let databaseName = "LIS4910" // name of your MySQL database
    static let username = "LIS4910"
    static let password = "music!@#$1234"
    
    static var parameters = [   /* Parameters are needed to pass into the Alamofire.request() function*/
        "h" : host,
        "d" : databaseName,
        "u" : username,
        "p" : password
    ]
    
    
    //MARK: Methods
    public class func ExecuteSelect(query: String) -> ([[String:Any]], StatusMsg){
        /* ***TO DO***: Figure out how to force errors; figure out when the alamofire.request() doesn't work and at what stage it failed */
        var ret = ResQuery()
        var status : StatusMsg
        
        parameters["e"] = query
        if (!checkQuery(query)){
            return (ret, (false, "Entered data not valid"))
        }
        let response = Alamofire.request(phpFile, method: .post, parameters: parameters).responseJSON()
        
        if let responserror = response.error {
            status = (false, String(describing: responserror)) /* If connection or php script failed */
        }
        else{
            let value = response.data
            do{ /* Must use "JSONSerialization.jsonObject()" */
                let json = try JSONSerialization.jsonObject(with: value!) as! [[String:Any]]
                ret = json
                status = (true, "Everything is OK")
            } catch {
                status = (false,String(describing: error)) /* If query failed */
            }
        }
        
        return (ret,status)
    }
    
    /* Modify SQL queries that use ExecuteSelect() function */
    public class func ExecuteModification(query: String) -> StatusMsg {
        let resquery = ExecuteSelect(query: query)
        return (resquery.1)
    }
    
    class func checkQuery(_ query : String) -> Bool {
        let arr = ["drop","modify"]
        
        for x in arr{
            if query.lowercased().range(of: x) != nil{
                return false
            }
        }
        return true
    } /* End of checkQuery() */
}

