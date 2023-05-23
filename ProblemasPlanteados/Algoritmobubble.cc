int main()
{
  int array [] = {64, 34, 25, 12, 22, 11, 90};
  int size = 7;
  bubbleSort(array, size);
  return 0;
}

void swap (int *xp, int *yp)
{
  int temp = *xp;
  *xp = *yp;
  *yp = temp;
}

void bubbleSort(int arr[], int n)
{
  int i, j;
  for(i = 0; i< n-1; i++)
    {
      //Last i element are already in place
      for (j = 0; j < n-i-1; j++)
        {
          if (arr[j] > arr[j+1])
            swap(&arr[j], &arr[j+1]);
        }
    }
}