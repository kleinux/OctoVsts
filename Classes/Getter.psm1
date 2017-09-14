Add-Type -Verbose -TypeDefinition @' 
public static class Getter 
{ 
    public static object Get(System.Object client, System.String path, System.Object args, System.Type type) 
    { 
        var method = client.GetType().GetMethod("Get");
        return method.MakeGenericMethod(type).Invoke(client, new object[] { path, args });
    } 
} 
'@ 