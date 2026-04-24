// Stub for missing connectorText types
export interface ConnectorTextBlock {
  type: 'connector_text'
  text: string
  connector_id?: string
}

export function isConnectorTextBlock(block: any): block is ConnectorTextBlock {
  return block?.type === 'connector_text'
}

export function extractConnectorTextBlocks(blocks: any[]): ConnectorTextBlock[] {
  return (blocks || []).filter(isConnectorTextBlock)
}
