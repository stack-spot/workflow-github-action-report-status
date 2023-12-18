# StackSpot Workflow Action Report Status

This action execute StackSpot Workflow Report Status

## Example usage

```yaml
- name: Stack Spot Workflow Report Status Started
  uses: stack-spot/workflow-github-action-report-status
  with:
    execution-id: "${{ github.event.inputs.execution-id }}"
    client-id: "${{ secrets.CLIENT_ID }}"
    client-secret: "${{ secrets.CLIENT_SECRET }}"
    realm: "${{ secrets.REALM }}"
    status: "started"
    
- name: Logs CLI
  if: failure()
  run: sudo cat /home/runner/work/_temp/_github_home/.stk/logs/logs.log
  
- name: Debug Http
  if: "${{ inputs.debug == 'true' && always() }}"
  run: sudo cat /home/runner/work/_temp/_github_home/.stk/debug/http.txt
  
- name: Example Workflow Step
  run: | 
    echo "Workflow Running...."
    sleep 10
    echo "Workflow Finished."
    
- name: Stack Spot Workflow Report Status Finished
  uses: stack-spot/workflow-github-action-report-status
  with:
    execution-id: "${{ github.event.inputs.execution-id }}"
    client-id: "${{ secrets.CLIENT_ID }}"
    client-secret: "${{ secrets.CLIENT_SECRET }}"
    realm: "${{ secrets.REALM }}"
    status: "finished"
```