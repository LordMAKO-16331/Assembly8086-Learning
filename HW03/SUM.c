
#include <stdio.h>

int main(void)
{
    int sum = 0;

    // 循环累加1到100
    for (int i = 1; i <= 100; i++)
    {
        sum += i;
    }

    // 输出求和结果
    printf("%d\n", sum);

    return 0;
}
