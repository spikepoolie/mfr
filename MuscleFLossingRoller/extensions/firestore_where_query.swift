import FirebaseFirestore

extension CollectionReference {
    func whereField(_ field: String, field_value: String, field1: String, file2_value: Any) -> Query {
        if field1 != "lastthree" {
            return whereField(field, isEqualTo: field_value).whereField(field1, isEqualTo: file2_value)
        } else {
             return whereField(field, isEqualTo: field_value)
        }
    }
}
