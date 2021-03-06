#!/usr/bin/env cwl-runner

cwlVersion: cwl:draft-4.dev1
$graph:

- id: echo
  class: CommandLineTool
  inputs:
    echo_in1:
      type: string
      inputBinding: {}
    echo_in2:
      type: string
      inputBinding: {}
  outputs:
    echo_out:
      type: string
      outputBinding:
        glob: "step1_out"
        loadContents: true
        outputEval: $(self[0].contents)
  baseCommand: "echo"
  arguments: ["-n", "foo"]
  stdout: step1_out

- id: main
  class: Workflow
  inputs:
    inp1:
      type: { type: array, items: string }
    inp2:
      type: { type: array, items: string }
  requirements:
    - class: ScatterFeatureRequirement
  steps:
    step1:
      scatter: ["#main/step1/echo_in1", "#main/step1/echo_in2"]
      scatterMethod: flat_crossproduct
      in:
        echo_in1: "#main/inp1"
        echo_in2: "#main/inp2"
      out: [echo_out]
      run: "#echo"

  outputs:
    out:
      source: "#main/step1/echo_out"
      type:
        type: array
        items: string
