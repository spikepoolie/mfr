import FirebaseFirestore

extension CollectionReference {
    func whereField(_ field: String, field_value: String, field1: String, file2_value: Any) -> Query {
        return whereField(field, isEqualTo: field_value).whereField(field1, isEqualTo: file2_value)
    }
}
