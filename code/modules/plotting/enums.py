class Status:
     Ok = 1
     Deactivated = 2
     Failed = 3 
     Expired = 4
     Stopped = 5

class Functions:
     GetMode = 1
     SetMode = 2
     MainFunction = 3
     CheckpointReached = 4
     PerformReset = 5
     GetFirstExpiredSeid = 6
     Init = 7
     GetLocalStatus = 8
     GetGlobalStatus = 9
     DeInit = 10

def status_names():
    return {   
        Status.Ok: "Ok",
        Status.Deactivated: "Deactivated",
        Status.Failed: "Failed",
        Status.Expired: "Expired",
        Status.Stopped: "Stopped"
    }

def function_names(): 
    return {
        Functions.GetMode: "GM",
        Functions.SetMode: "SM",
        Functions.MainFunction: "MF",
        Functions.CheckpointReached: "CR",
        Functions.PerformReset: "PR",
        Functions.GetFirstExpiredSeid: "GFES",
        Functions.Init: "I",
        Functions.GetLocalStatus: "GLS",
        Functions.GetGlobalStatus: "GGS",
        Functions.DeInit: "DI"
    }

    
def format_function(i):
     return function_names()[i] 

def format_status(i):
     return status_names()[i]
