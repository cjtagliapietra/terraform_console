%title: Terraform Console
%author: ctaglia

-> ## Terraform Console -  Función <-
====

> Consola interactiva para exeperimentar con interpolaciones
  
> Para interactuar con el state (si hay uno)


_Cómo la ejecutamos?_

*terraform console*
*terragrunt console*

_NOTA:_ Tenemos que tener en cuenta que mientras este en ejecucion 
        tomará el lock del state en el que nos encontremos.

-------------------------------------------------

-> ## Interpolaciones <-

Por ejemplo:

  *nombres = [for s in range(3) : "nombre-${s}"]*

Escapando el **$**

  *[for s in range(3) : "nombre-$${s}"]*

O cualquier funcion de terraform:

  *max(), join(), split(), etc*

-------------------------------------------------
-> ## Si utilizamos un archivo de infra <-

Veamos como se compone la variable

*var.instancias*

Ejemplo: generamos un _user-data_ que devuelva algo asi:

    Hostname=ec2-1 
    IpAddress=10.0.0.10:8080 
    Hostname=ec2-2 
    IpAddress=10.0.0.20:8080
    

    locals {
      user-data = << EOT
    %{ for instance in var.instancias ~}
    Hostname=${instance.hostname} 
    IpAddress=${instance.ip_address}:8080
    %{ endfor }
    EOT
    }

-------------------------------------------------


-> ## De que otra manera podemos hacer todo esto? <-
<br>

-> _*OUTPUTS*_ <-
<br>

-> ### La desventaja es que tenemos que esperar el _terraform plan_ ### <-

-------------------------------------------------

-> ## Interactuar con el state (debug) <-

> Por ejemplo: entender alguna variable compleja

    private_subnets = [
      for i in range(length(var.azs)) :
      cidrsubnet(var.cidr, var.newbits, i)
    ]
<br>

> O si necesitamos ver la Ip de un host 

*google_redis_instance.redis.host*
<br>

> O necesitamos ver un secret
 
*google_redis_instance.redis.auth_string*

*nonsensitive(google_redis_instance.redis.auth_string)* 

A veces es mas rápido acceder al secret a traves del state (random_password) 
que ir hasta el Secret Manager

-------------------------------------------------

-> ## Interactuar con el state (develop) <-

> Ejemplo: necesitamos customizar una variable *user-data*. 

*data.template_file.file[0].template*
<br>

> Que pasa si modifico el archivo de terraform? 

    data template_file "test" {
      template = file("/etc/services")
    }

*data.template_file.test*
<br>

-------------------------------------------------

-> ## Interactuar con el state (import) <-

> O necesito importar en terraform un recurso ya desplegado.


_Ejemplo, importar un attachment segun la documentación:_

-> IAM role policy attachments can be imported using the *role name and policy arn separated by /*. <-

    resource "aws_iam_role_policy_attachment" "ecs_default" {
    
      role       = aws_iam_role.execution_role.name
      policy_arn = data.aws_iam_policy.ecs_default.arn

    }

-------------------------------------------------



-> ## Preguntas? <-
<br>



-> # FIN <-
-------------------------------------------------
