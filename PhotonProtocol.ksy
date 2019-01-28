meta:
  id: photon_protocol
  endian: be
seq:
  - id: photon_header
    type: photon_header

types:
  photon_header:
    seq:
      - id: peer_id
        type: u2
      - id: flag
        type: u1
      - id: command_count
        type: u1
      - id: timestamp
        type: u4
      - id: challenge
        type: u4
      - id: crc
        type: u4
        if: flag == 204
      - id: commands
        type: command_header
        repeat: expr
        repeat-expr: command_count
  command_header:
    seq:
      - id: command_type
        type: u1
        enum: command_type
      - id: channel_id
        type: u1
      - id: command_flags
        type: u1
      - id: reserved_byte
        type: u1
      - id: command_length
        type: u4
      - id: reliable_sequence_number
        type: u4
      - id: unreliable_sequence_number
        type: u4
      - id: message
        type: message
        size: command_length-16
  message:
    seq:
      - id: message_signifier_byte
        contents: [0xF3]
      - id: message_type
        type: u1
        enum: message_type
      - id: event_code
        type: u1
      - id: parameter_count
        type: u2
      - id: parameter
        type: parameter
        repeat: expr
        repeat-expr: parameter_count
  
  parameter:
    seq:
      - id: param_num
        type: u1
      - id: data_type
        type: u1
        enum: parameter_type
      - id: param_body
        type:
          switch-on: data_type
          cases:
            'parameter_type::byte': u2
            'parameter_type::long': u8
            'parameter_type::byte_array': byte_array

  byte_array:
    seq:
      - id: length
        type: u4
      - id: bytebody
        size: length
      
enums:
  command_type:
    0: none
    1: acknowledge
    2: connect
    3: verify_connect
    4: disconnect
    5: ping
    6: send_reliable
    7: send_unreliable
    8: send_reliable_fragment
    12: server_time
    
  message_type:
    0: initialize
    1: initialize_response
    2: operation_request
    3: operation_response
    4: event
    6: internal_operation_request
    7: internal_operation_response
    8: message
    9: rawmessage
    
  parameter_type:
    0: unknown
    42: 'null'
    68: dictionary
    97: string_array
    98: byte
    99: custom
    100: double
    101: event_data
    102: float
    104: hashtable
    105: integer
    107: short
    108: long
    110: integer_array
    111: boolean
    112: operation_response
    113: operation_request
    115: string
    120: byte_array
    121: array
    122: object_array
