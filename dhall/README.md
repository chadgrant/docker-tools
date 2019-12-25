## example

```bash
	docker run --rm -it \
    -v ${PWD}:/go/src/github.com/chadgrant/sample-grpc \
	-w /go/src/github.com/chadgrant/sample-grpc/ \
	chadgrant/protobuff:3.6.1 \
	--gogo_out=./proto --proto_path=./proto \
	-I /go/src \
	-I /go/src/github.com/grpc-ecosystem/grpc-gateway/third_party/googleapis \
	-I /go/src/github.com/grpc-ecosystem/grpc-gateway/ \
	-I /go/src/github.com/gogo/protobuf/protobuf/ \
	--gogo_out=plugins=grpc,\
Mgoogle/protobuf/timestamp.proto=github.com/gogo/protobuf/types,\
Mgoogle/api/annotations.proto=github.com/gogo/googleapis/google/api,\
Mgoogle/protobuf/field_mask.proto=github.com/gogo/protobuf/types:/go/src/ \
  --grpc-gateway_out=allow_patch_feature=false,\
Mgoogle/protobuf/timestamp.proto=github.com/gogo/protobuf/types,\
Mgoogle/api/annotations.proto=github.com/gogo/googleapis/google/api,\
Mgoogle/protobuf/field_mask.proto=github.com/gogo/protobuf/types:/go/src/ \
  --govalidators_out=gogoimport=true,\
Mgoogle/protobuf/timestamp.proto=github.com/gogo/protobuf/types,\
Mgoogle/api/annotations.proto=github.com/gogo/googleapis/google/api,\
Mgoogle/protobuf/field_mask.proto=github.com/gogo/protobuf/types:/go/src/ \
  --swagger_out=logtostderr=true,fqn_for_swagger_name=false:./swagger/ \
 	./proto/servicestatus.proto
```