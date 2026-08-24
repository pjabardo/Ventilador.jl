module Ventilador

export ventilador , connect, run!,stop!,sendRPM!
using MQTTClient


rpm_topic = "tunel/rpm"         # Topico RPM
status_topic = "tunel/status"   # Topico Status

 ## --------- Função para conectar no broker --------------------------#
    

 





function callback(topic,payload)
    return println("Mensagem recebida no topico: [",topic,"] mensagem: [",String(payload),"]")

end

mutable struct connect   ## Estrutura de dados para armazenar as informações do ventilador 
    lab::String             #laboratório
    broker::String          #IP do broker
    port::Int               # Porta do broker
    rpm_topic::String       #Topico do RPM
    status_topic::String    #Topico do Status



function connect(lab::String)
   if (lab == "tunel")
        print("Configurando Conexão MQTT com o ventilador do túnel de vento\n")
        broker = "192.168.0.180"
        port = 1883
        usuario = "tunel"
        senha = "gvento123" 
        devname = "TUNEL"


        user = User(usuario, senha)
        client, connection = MakeConnection(broker, port; user=user)
        MQTTClient.connect(client, connection)
 
        MQTTClient.subscribe(client, rpm_topic,callback,qos=QOS_2)
        MQTTClient.subscribe(client, status_topic,callback,qos=QOS_2)

    elseif (lab =="anemometria")
        print("Configurando Conexão MQTT com o ventilador do laboratório de Anemometria\n")
        broker = "192.168.0.181"
        port = 4747
        usuario = ""
        senha = " " 
        devname = "anemometria"
        
        user = User(usuario, senha)
        client, connection = MakeConnection(broker, port; user=user)
        MQTTClient.connect(client, connection)
 
        MQTTClient.subscribe(client, rpm_topic,callback,qos=QOS_2)
        MQTTClient.subscribe(client, status_topic,callback,qos=QOS_2)
    else
        error("Laboratório desconhecido: $lab. Use \"tunel\" ou \"anemometria\".")
    end
    
    #new( lab,broker, port, rpm_topic, status_topic)
    return client
    
    end
end

function Base.show(io::IO, v::connect) ## ,Função para mostrar as informações do ventilador
    println(io, "Laboratório : ", v.lab) 
    println(io, "IP broker   : ", v.broker)
    println(io, "Porta       : ", v.port)
    println(io, "Topico RPM  : ", v.rpm_topic)
    println(io, "Topico Status: ", v.status_topic)  
end
           
function run!(tunel)
println( "Ligando tunel")
  MQTTClient.publish(tunel, status_topic, "run"; qos=QOS_2)

end


function stop!(tunel)
    println( "Desligando tunel")
   MQTTClient.publish(tunel, status_topic, "stop"; qos=QOS_2)

end
function sendRPM!(tunel, rpm)
    println( "Enviando RPM: ", rpm)
    MQTTClient.publish(tunel, rpm_topic, string(rpm); qos=QOS_2)
end
end #module Ventilador