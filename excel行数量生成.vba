Sub cf()
  h = Range("A1").End(xlDown).Row 'A1�зǿ�����
  Rows("1:1").Copy
  hn = h + 5
  Cells(hn, 1).Select
  ActiveSheet.Paste     '����5�в�ճ��
  
  For i = 2 To h
    k = Cells(i, 3)     'ȡ���Ƶ�����
        For j = 1 To k
            hn = hn + 1
            Cells(hn, 1) = Cells(i, 1)
            Cells(hn, 2) = Cells(i, 2)
            Cells(hn, 3) = 1    '
    Next j
  Next i
End Sub
