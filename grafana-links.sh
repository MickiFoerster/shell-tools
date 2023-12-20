function grafana_network_received_bytes() {
    ${BROWSER} 'http://grafana.home/explore?orgId=1&left=%5B%22now-6h%22,%22now%22,%22Prometheus%22,%7B%22refId%22:%22A%22,%22instant%22:true,%22range%22:true,%22exemplar%22:true,%22expr%22:%22rate(node_network_receive_bytes_total%7Binstance%3D~%5C%22.*.home:9100%7C192.*%5C%22,device%3D~%5C%22e.*%7Cw.*%5C%22%7D%5B5m%5D)%22%7D%5D'
}

function grafana_network_transmitted_bytes() {
    ${BROWSER} 'http://grafana.home/explore?orgId=1&left=%5B%22now-6h%22,%22now%22,%22Prometheus%22,%7B%22refId%22:%22A%22,%22instant%22:true,%22range%22:true,%22exemplar%22:true,%22expr%22:%22rate(node_network_transmit_bytes_total%7Binstance%3D~%5C%22.*.home:9100%7C192.*%5C%22,device%3D~%5C%22e.*%7Cw.*%5C%22%7D%5B5m%5D)%22%7D%5D'
}
