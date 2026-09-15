# Vendor Telemetry Analyzer(VTA)
El presente proyecto es un analizador basado en Wireshark + Lua orientado a identificar y clasificar el tráfico de la red asociado a telemetría, reconocimiento automático de contenido (ACR), publicidad y otros servicios relacionados con dispositivos Smart TV, plataformas conectadas y IOT .

VTA utiliza un registro de dominios asociado a diferentes fabricantes y plataformas para facilitar la identificación del tráfico observado durante una captura de red.
<h3>Objetivos del Proyecto</h3>
<ul>
<li>Identificar dominios asociados a servicios de telemetría de dispositivos conectados(absolutamente editable).</li>
<li>Clasificar tráfico relacionado con telemetría, ACR, publicidad y tracking.</li>
<li>Facilitar el análisis de comunicaciones de Smart TV mediante Wireshark.</li>
<li>Mantener un registro de dominios de fabricantes que pueda ampliarse con nuevos dispositivos, plataformas y servicios.</li>
<li>Reducir la necesidad de revisar manualmente cada hostname observado durante una captura.(Reporte en vivo).</li>
</ul></br>
Importante: la identificación mediante dominio constituye un indicador de actividades.
<h3>Arquitectura</h3>

<div align="center">
  <img src="https://github.com/user-attachments/assets/b67c22fa-d799-442f-9c1e-031a04b870401" height="500" alt="Image">
</div></br>
<strog>El archivo funciona como postdissector de Wireshark. Los hostnames listados son normalizados y comparados con el registro de dominios.</strog>

<h3>Requisitos</h3>
<h4>Software</h4>
<ul>
  <li>Wireshark (5.2 version testeada)</li>
  <li>Lua(incluido en la distribución de Wireshark)</li>
  <li>Npcap</li>
</ul>
<h3>Instalación</h3>
Descarga o clona el repositorio:

```
git clone https://github.com/baruc90/VendorTelemetryAnalyzer-VTA-.git
cd VendorTelemetryAnalyzer-VTA-
```
Copia smarttv.lua al directorio de plugins personales de Wireshark.

La ubicación depende del sistema operativo.

En Wireshark puede comprobarse el directorio correspondiente desde:

Help → About Wireshark → Folders
<img width="910" height="845" alt="Captura de pantalla 01" src="https://github.com/user-attachments/assets/88e8768b-bb19-42ac-84d4-bab305c38548" />

Una vez instalado el script, reinicia Wireshark.

Comprueba que el plugin se haya cargado correctamente mediante:

Help → About Wireshark → Plugins

* Algunas veces la carpeta plugin no está creada, para ello puedes crearla manualmente con el nombre de "plugin", debería quedar así.
  C:\Users\(Your-username)\AppData\Roaming\Wireshark\plugins
Comprueba que el plugin se haya cargado correctamente mediante:

Help → About Wireshark → Plugins
  
<img width="917" height="847" alt="Captura de pantalla 02" src="https://github.com/user-attachments/assets/0f556b77-a317-451a-a14b-c33cb7a35d48" />


