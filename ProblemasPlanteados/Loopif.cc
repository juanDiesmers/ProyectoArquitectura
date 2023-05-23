int main(){
    int numbers[]= {1,21,45,66,98,85,78,4,55,48};
    int size = 10;
    int index;
    int key = 66; // key can be an of the numbres in array

    for(int i =0; i < size; i++){
        if(key==numbers[i]){
            key=i;
        }
    }
}